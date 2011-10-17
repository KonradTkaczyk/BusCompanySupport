class BusesController < ApplicationController
  # GET /buses
  # GET /buses.xml
  def index
    @buses = Bus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @buses }
    end
  end

  # GET /buses/1
  # GET /buses/1.xml
  def show
    @bus = Bus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bus }
    end
  end

  # GET /buses/new
  # GET /buses/new.xml
  def new
    @bus = Bus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bus }
    end
  end

  # GET /buses/1/edit
  def edit
    @bus = Bus.find(params[:id])
  end

  # POST /buses
  # POST /buses.xml
  def create
    @bus = Bus.new(params[:bus])

    respond_to do |format|
      if @bus.save
        format.html { redirect_to(@bus, :notice => 'Bus was successfully created.') }
        format.xml  { render :xml => @bus, :status => :created, :location => @bus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /buses/1
  # PUT /buses/1.xml
  def update
    @bus = Bus.find(params[:id])

    respond_to do |format|
      if @bus.update_attributes(params[:bus])
        format.html { redirect_to(@bus, :notice => 'Bus was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /buses/1
  # DELETE /buses/1.xml
  def destroy
    @bus = Bus.find(params[:id])
    @bus.destroy

    respond_to do |format|
      format.html { redirect_to(buses_url) }
      format.xml  { head :ok }
    end
  end
end
