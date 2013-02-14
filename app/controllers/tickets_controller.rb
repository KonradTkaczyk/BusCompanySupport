class TicketsController < ApplicationController

   before_filter :authenticate
   before_filter :admin_user,   :only => [:create, :destroy, :edit, :update]

  def reserved_index
    @tickets = Ticket.where(:user_reserved_id => current_user.id)
    logger.debug(@tickets.first.cityFrom)
    logger.debug(@tickets.first.cityTo)
    logger.debug(@tickets.first.trip)
    logger.debug(@tickets.length)
    logger.debug(@tickets.last.cityFrom)
    logger.debug(@tickets.last.cityTo)
    logger.debug(@tickets.last.trip)
    respond_to do |format|
      format.html # reserved_index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  def index
    @tickets = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ?", Time.now - 30.minutes).order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets
  # GET /tickets.xml
  def search
    if(params.has_key?(:ticket))
      @tickets = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ? AND cityFrom LIKE ? AND cityTo LIKE ?", Time.now - 30.minutes, "%#{params[:ticket][:cityFrom]}%", "%#{params[:ticket][:cityTo]}%")
      if @tickets.length == 0 # if no direct connection found then search for closest path to reach the destination.
        @tickets = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ?", Time.now - 30.minutes)
      end
      if @tickets.length != 0
        array = Array.new()
        array2 = Array.new()
        i = 0
        j = 0
        @tickets.each do |ticket| #adding all tickets data to array to provide to Dijkstra algorithm
          array.push(ticket.cityFrom)
          array.push(ticket.cityTo)
          array.push(ticket.cost_of_trip)
          if (!array2.include?(array)) #adding only paths that are not in array already
            array2.push(Array.new(array))
          end
          array.clear
          if ticket.cityFrom == params[:ticket][:cityFrom]
            i = i + 1
          end
          if ticket.cityTo == params[:ticket][:cityTo]
            j = j + 1
          end
        end
        if i > 0 and j > 0
          g = TicketsHelper::Graph.new (array2)
          start = g.vertices[params[:ticket][:cityFrom]]
          stop  = g.vertices[params[:ticket][:cityTo]]
          path = g.shortest_path(start, stop)
          puts "shortest path from #{start.name} to #{stop.name} has cost #{Time.at(stop.dist).gmtime.strftime('%R:%S')}:"
          shortest = Array.new(path.map {|vertex| vertex.name})
          @tickets = Ticket.tickets_for_shortest_path(shortest)
          @ticketsTrip = Array.new
          @tickets.collect{ |ticket| @ticketsTrip.push(ticket.trip)}
          respond_to do |format|
            format.html { render :shortest_path }
            format.xml  { render :xml => @tickets }
          end
        end
      else
      @tickets = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ?", Time.now - 30.minutes)
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @tickets }
        end
      end
    end
  end

  def reserveAll
    @userTickets = Ticket.where("user_reserved_id = ? AND dateOfTrip > ?", current_user.id, Time.now - 30.minutes)
    @tickets = Ticket.find(params[:tickets])
    if(@userTickets.length <= 10 && 10 - @userTickets.length - @tickets.length >= 0) #defines how many tickets user can have reserved at once -> default 10 tickets
      @tickets.each do |ticket|
        if ticket.user_reserved_id == 0
          ticket.user_reserved_id = current_user.id
          ticket.save
        end
      end
      respond_to do |format|
        format.html { redirect_to(reserved_index_ticket_path) }
        format.xml  { head :ok }
      end
    else
      flash[:error] = "You cannot have more than 10 reserved tickets at once - no reservations done"
      redirect_to tickets_path
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
    @userTickets = Ticket.where("user_reserved_id = ? AND dateOfTrip > ?", current_user.id, Time.now - 30.minutes)
    if(@userTickets.length <= 10)
      @ticket = Ticket.where("trip = ? AND nameOfSeat = ?", params[:TripID],params[:SeatNumber]).first
      @ticket.user_reserved_id = current_user.id
      @ticket.save
      respond_to do |format|
        format.html { redirect_to(reserved_index_ticket_path) }
        format.xml  { head :ok }
      end
    else
      flash[:error] = "You cannot have more than 10 reserved tickets at once - no reservation done"
      redirect_to tickets_path
    end
  end

  def unreserve
    @ticket = Ticket.where("trip = ? AND nameOfSeat = ?", params[:TripID],params[:SeatNumber]).first
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
    logger.debug(startTime)
    endTime = DateTime.new(params[:ticket]["endOfTrip(1i)"].to_i,
                             params[:ticket]["endOfTrip(2i)"].to_i,
                             params[:ticket]["endOfTrip(3i)"].to_i,
                             params[:ticket]["endOfTrip(4i)"].to_i,
                             params[:ticket]["endOfTrip(5i)"].to_i)
    #Find all tickets from 3 days before start of the trip
    @tickets = Ticket.where("dateOfTrip > ? AND endOfTrip < ? AND bus_id = ? AND endOfTrip > ? AND dateOfTrip < ?", startTime - 3.days, endTime + 3.days, params[:ticket][:bus_id], startTime, endTime)
    if (endTime > startTime && @tickets.length == 0)
      n = Bus.find(Integer(params[:ticket][:bus_id])).capacity
      m = Ticket.maximum("trip") + 1
      (1..n).each do |i|
        @ticket = current_user.tickets.build(params[:ticket])
        @ticket.user_reserved_id = 0
        @ticket.nameOfSeat = i
        @ticket.trip = m
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

