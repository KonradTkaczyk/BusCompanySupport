require 'json'

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

  def index
    @tickets = Ticket.where("user_reserved_id = 0 AND date_of_trip > ?", Time.now - 30.minutes).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 200)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tickets }
    end
  end

  # GET /tickets
  # GET /tickets.xml
  def search
    if(params.has_key?(:ticket))
      @tickets = Ticket.where("user_reserved_id = 0 AND date_of_trip > ? AND city_from LIKE ? AND city_to LIKE ?", Time.now - 30.minutes, "%#{params[:ticket][:city_from]}%", "%#{params[:ticket][:city_to]}%")
      if @tickets.length == 0 # if no direct connection found then search for closest path to reach the destination.
        @tickets = Ticket.where("user_reserved_id = 0 AND date_of_trip > ?", Time.now - 30.minutes)
      end
      if @tickets.length != 0
        array = Array.new()
        array2 = Array.new()
        i = 0
        j = 0
        @tickets.each do |ticket| #adding all tickets data to array to provide to Dijkstra algorithm
          array.push(ticket.city_from)
          array.push(ticket.city_to)
          array.push(ticket.cost_of_trip)
          if (!array2.include?(array)) #adding only paths that are not in array already
            array2.push(Array.new(array))
          end
          array.clear
          if ticket.city_from == params[:ticket][:city_from]
            i = i + 1
          end
          if ticket.city_to == params[:ticket][:city_to]
            j = j + 1
          end
        end
        if i > 0 and j > 0
          g = TicketsHelper::Graph.new (array2)
          start = g.vertices[params[:ticket][:city_from]]
          stop  = g.vertices[params[:ticket][:city_to]]
          path = g.shortest_path(start, stop)
          puts "shortest path from #{start.name} to #{stop.name} has cost #{Time.at(stop.dist).gmtime.strftime('%R:%S')}:"
          shortest = Array.new(path.map {|vertex| vertex.name})
          @tickets = Ticket.tickets_for_shortest_path(shortest)
          if @tickets == nil
            flash[:error] = "No route has been found"
            respond_to do |format|
              format.html { redirect_to(tickets_path) }
              format.xml  { head :ok }
            end
            return
          end
          @ticketsTrip = Array.new
          @tickets.collect{ |ticket| @ticketsTrip.push(ticket.trip)} #tickets found are pushed to array which will be presented in results page
          respond_to do |format|
            format.html { render :shortest_path }
            format.xml  { render :xml => @tickets }
          end
        end
      else
      @tickets = Ticket.where("user_reserved_id = 0 AND date_of_trip > ?", Time.now - 30.minutes)
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @tickets }
        end
      end
    end
  end

  def reserveAll
    arrayOfTrips = JSON.parse(params[:ArrayOfTrips])
    logger.debug(arrayOfTrips)
    trips = Array.new()
    arrayOfTrips.collect{ |trip| trips.push(trip.first)} #array of trips which is used to find all trip tickets
    @userTickets = Ticket.where("user_reserved_id = ? AND date_of_trip > ?", current_user.id, Time.now - 30.minutes)
    @tickets = Ticket.where(:trip => trips)
    logger.debug(@tickets.length)
    if((@userTickets.length <= 50 && 50 - @userTickets.length - @tickets.length >= 0)|| true) #defines how many tickets user can have reserved at once -> default 10 tickets
      arrayOfTrips.each do |x| #go through all arrays with seats sended via AJAX
        logger.debug("----+++---")
        if(x.length>=2) #all arrays which have seats as they are from second element of the array
          tripid = nil
          x.each_with_index do |y,index| #go through all tickets for one trip, first element of array is trip ID
            if(index == 0)
              logger.debug("--")
              tripid = y
            else
              logger.debug("-------")
              ticket = Ticket.where("user_reserved_id = 0 AND trip = ? AND name_of_seat = ?",tripid,y).first
              ticket.user_reserved_id = current_user.id
              ticket.save
            end
          end
        end
      end
      #ticket.user_reserved_id = current_user.id
      #ticket.save
      respond_to do |format|
        format.json { render :json => { :result => 'success'} }
      end
    else
      respond_to do |format|
        format.json { render :json => { :result => 'failure'} }
      end
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
    logger.debug(params)
    @userTickets = Ticket.where("user_reserved_id = ? AND date_of_trip > ?", current_user.id, Time.now - 30.minutes)
    if(@userTickets.length <= 10)
      @ticket = Ticket.where("trip = ? AND name_of_seat = ?", params[:TripID],params[:SeatNumber]).first
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
    @ticket = Ticket.where("trip = ? AND name_of_seat = ?", params[:TripID],params[:SeatNumber]).first
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
    startTime = DateTime.new(params[:ticket]["date_of_trip(1i)"].to_i,
                             params[:ticket]["date_of_trip(2i)"].to_i,
                             params[:ticket]["date_of_trip(3i)"].to_i,
                             params[:ticket]["date_of_trip(4i)"].to_i,
                             params[:ticket]["date_of_trip(5i)"].to_i)
    logger.debug(startTime)
    endTime = DateTime.new(params[:ticket]["end_of_trip(1i)"].to_i,
                             params[:ticket]["end_of_trip(2i)"].to_i,
                             params[:ticket]["end_of_trip(3i)"].to_i,
                             params[:ticket]["end_of_trip(4i)"].to_i,
                             params[:ticket]["end_of_trip(5i)"].to_i)
    #Find all tickets from 3 days before start of the trip
    @tickets = Ticket.where("date_of_trip > ? AND end_of_trip < ? AND bus_id = ? AND end_of_trip > ? AND date_of_trip < ?", startTime - 3.days, endTime + 3.days, params[:ticket][:bus_id], startTime, endTime)
    if (endTime > startTime && @tickets.length == 0)
      n = Bus.find(Integer(params[:ticket][:bus_id])).capacity
      m = Ticket.maximum("trip") + 1
      (1..n).each do |i|
        @ticket = current_user.tickets.build(params[:ticket])
        @ticket.user_reserved_id = 0
        @ticket.name_of_seat = i
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
      flash[:error] = "Another ticket exist which collide with the dates. Ticket starting: #{@tickets[0].date_of_trip} and ending: #{@tickets[0].end_of_trip} "
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
      Ticket.column_names.include?(params[:sort]) ? params[:sort] : "date_of_trip" #Protection against SQL injection (allows only names from column names available for class Ticket)
    end
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc" #Protection against SQL injection (allows only ascending and descending orders)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

