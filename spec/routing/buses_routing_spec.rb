require "spec_helper"

describe BusesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/buses" }.should route_to(:controller => "buses", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/buses/new" }.should route_to(:controller => "buses", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/buses/1" }.should route_to(:controller => "buses", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/buses/1/edit" }.should route_to(:controller => "buses", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/buses" }.should route_to(:controller => "buses", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/buses/1" }.should route_to(:controller => "buses", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/buses/1" }.should route_to(:controller => "buses", :action => "destroy", :id => "1")
    end

  end
end
