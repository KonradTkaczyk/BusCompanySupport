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
    @tickets = Ticket.where(:user_reserved_id => 0)

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
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create
    @ticket = current_user.tickets.build(params[:ticket])

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to(@ticket, :notice => 'Ticket was successfully created.') }
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
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

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

