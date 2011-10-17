require "spec_helper"

describe SeatsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/seats" }.should route_to(:controller => "seats", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/seats/new" }.should route_to(:controller => "seats", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/seats/1" }.should route_to(:controller => "seats", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/seats/1/edit" }.should route_to(:controller => "seats", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/seats" }.should route_to(:controller => "seats", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/seats/1" }.should route_to(:controller => "seats", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/seats/1" }.should route_to(:controller => "seats", :action => "destroy", :id => "1")
    end

  end
end
