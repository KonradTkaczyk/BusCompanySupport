class TicketsController < ApplicationController
   before_filter :authenticate
   before_filter :admin_user,   :only => [:create, :destroy, :edit, :update]

  def reserved_index
    @tickets = Ticket.where(:user_reserved_id => current_user.id)
    respond_to do |format|
      format.html # reserved_index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets
  # GET /tickets.xml
  def index
    @tickets = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ? AND cityFrom LIKE ? AND cityTo LIKE ?", Time.now - 30.minutes, "%#{params[:search]}%", "%#{params[:search2]}%").order(sort_column + " " + sort_direction).paginate(:page => params[:page])
    if @tickets.length == 0 # if no direct connection found then search for closest path to reach the destination.
      @tickets = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ?", Time.now - 30.minutes).paginate(:page => params[:page])
      array = Array.new()
      array2 = Array.new()
      @tickets.each do |ticket|
        array.push(ticket.cityFrom)
        array.push(ticket.cityTo)
        array.push(ticket.cost_of_trip)
        array2.push(Array.new(array))
        array.clear
      end
      g = TicketsHelper::Graph.new (array2)
      start = g.vertices[params[:search]]
      stop  = g.vertices[params[:search2]]
      path = g.shortest_path(start, stop)
      puts "shortest path from #{start.name} to #{stop.name} has cost #{Time.at(stop.dist).gmtime.strftime('%R:%S')}:"
      puts path.map {|vertex| vertex.name}.join(" -> ")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  def reserve
    @ticket = Ticket.find(params[:id])
    @ticket.user_reserved_id = current_user.id
    @ticket.save
    respond_to do |format|
      format.html { redirect_to(reserved_index_ticket_path) }
      format.xml  { head :ok }
    end
  end

  def unreserve
    @ticket = Ticket.find(params[:id])
    if @ticket.user_reserved_id != current_user.id
      flash[:error] = "You cannot unreserve a ticket which you did not reserve!"
      redirect_to tickets_path
    else
      @ticket.user_reserved_id = 0
      @ticket.save
      respond_to do |format|
        format.html { redirect_to(tickets_url) }
        format.xml  { head :ok }
      end
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    @ticket = Ticket.new
    @Buses = Bus.all
    if @Buses.count == 0
      flash[:error] = "You cannot create a ticket without a bus!"
      redirect_to buses_path
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @ticket }
      end
    end
  end

  # GET /tickets/1/edit
  def edit
    @Buses = Bus.all
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    error = false
    startTime = DateTime.new(params[:ticket]["dateOfTrip(1i)"].to_i,
                             params[:ticket]["dateOfTrip(2i)"].to_i,
                             params[:ticket]["dateOfTrip(3i)"].to_i,
                             params[:ticket]["dateOfTrip(4i)"].to_i,
                             params[:ticket]["dateOfTrip(5i)"].to_i)
    endTime = DateTime.new(params[:ticket]["endOfTrip(1i)"].to_i,
                             params[:ticket]["endOfTrip(2i)"].to_i,
                             params[:ticket]["endOfTrip(3i)"].to_i,
                             params[:ticket]["endOfTrip(4i)"].to_i,
                             params[:ticket]["endOfTrip(5i)"].to_i)
    #Find all tickets from 3 days before start of the trip
    @tickets = Ticket.where("dateOfTrip > ? AND endOfTrip < ? AND bus_id = ? AND endOfTrip > ? AND dateOfTrip < ?", startTime - 3.days, endTime + 3.days, params[:ticket][:bus_id], startTime, endTime)
    if (endTime > startTime && @tickets.length == 0)
      n = Bus.find(Integer(params[:ticket][:bus_id])).capacity
      (1..n).each do |i|
        @ticket = current_user.tickets.build(params[:ticket])
        @ticket.user_reserved_id = 0
        @ticket.nameOfSeat = i
        if !@ticket.save
          respond_to do |format|
            format.html { render :action => "new" }
            format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
          end
        end
      end
      respond_to do |format|
          format.html { redirect_to(@ticket, :notice => 'Tickets were successfully created.') }
          format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      end
    elsif(endTime < startTime)
      flash[:error] = "You cannot create a ticket which ends sooner than it starts!!!"
      redirect_to new_ticket_path
    elsif(@tickets.length != 0)
      flash[:error] = "Another ticket exist which collide with the dates. Ticket starting: #{@tickets[0].dateOfTrip} and ending: #{@tickets[0].endOfTrip} "
      redirect_to new_ticket_path
    else
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end

  private
    def sort_column
      Ticket.column_names.include?(params[:sort]) ? params[:sort] : "dateOfTrip" #Protection against SQL injection (allows only names from column names available for class Ticket)
    end
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc" #Protection against SQL injection (allows only ascending and descending orders)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

