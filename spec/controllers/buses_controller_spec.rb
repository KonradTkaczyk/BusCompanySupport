require 'spec_helper'

describe BusesController do

  def mock_bus(stubs={})
    (@mock_bus ||= mock_model(Bus).as_null_object).tap do |bus|
      bus.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all buses as @buses" do
      Bus.stub(:all) { [mock_bus] }
      get :index
      assigns(:buses).should eq([mock_bus])
    end
  end

  describe "GET show" do
    it "assigns the requested bus as @bus" do
      Bus.stub(:find).with("37") { mock_bus }
      get :show, :id => "37"
      assigns(:bus).should be(mock_bus)
    end
  end

  describe "GET new" do
    it "assigns a new bus as @bus" do
      Bus.stub(:new) { mock_bus }
      get :new
      assigns(:bus).should be(mock_bus)
    end
  end

  describe "GET edit" do
    it "assigns the requested bus as @bus" do
      Bus.stub(:find).with("37") { mock_bus }
      get :edit, :id => "37"
      assigns(:bus).should be(mock_bus)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created bus as @bus" do
        Bus.stub(:new).with({'these' => 'params'}) { mock_bus(:save => true) }
        post :create, :bus => {'these' => 'params'}
        assigns(:bus).should be(mock_bus)
      end

      it "redirects to the created bus" do
        Bus.stub(:new) { mock_bus(:save => true) }
        post :create, :bus => {}
        response.should redirect_to(bus_url(mock_bus))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bus as @bus" do
        Bus.stub(:new).with({'these' => 'params'}) { mock_bus(:save => false) }
        post :create, :bus => {'these' => 'params'}
        assigns(:bus).should be(mock_bus)
      end

      it "re-renders the 'new' template" do
        Bus.stub(:new) { mock_bus(:save => false) }
        post :create, :bus => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested bus" do
        Bus.should_receive(:find).with("37") { mock_bus }
        mock_bus.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :bus => {'these' => 'params'}
      end

      it "assigns the requested bus as @bus" do
        Bus.stub(:find) { mock_bus(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:bus).should be(mock_bus)
      end

      it "redirects to the bus" do
        Bus.stub(:find) { mock_bus(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(bus_url(mock_bus))
      end
    end

    describe "with invalid params" do
      it "assigns the bus as @bus" do
        Bus.stub(:find) { mock_bus(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:bus).should be(mock_bus)
      end

      it "re-renders the 'edit' template" do
        Bus.stub(:find) { mock_bus(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested bus" do
      Bus.should_receive(:find).with("37") { mock_bus }
      mock_bus.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the buses list" do
      Bus.stub(:find) { mock_bus }
      delete :destroy, :id => "1"
      response.should redirect_to(buses_url)
    end
  end

end
