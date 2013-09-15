require 'spec_helper'
require "watir-webdriver"
require 'watir-webdriver/extensions/alerts'

browser = Watir::Browser.new
location_of_BCS = "http://localhost"
port_of_BCS = "3000"
link_to_BCS = location_of_BCS + ":" + port_of_BCS

RSpec.configure do |config|
	config.after(:suite) { browser.close unless browser.nil? }
end

describe "Test the driver functionalities" do
	before(:each) do
		browser.goto link_to_BCS + '/log_in'
		browser.text_field(:name => 'session[email]').when_present.set("driver@bcs.org")
		browser.text_field(:name => 'session[password]').when_present.set("foobar")
		browser.button(:value => "Log in").when_present.click
	end

	describe "Main page buttons" do
		it "should consist of the main menu page" do
			browser.text.should_not include('List of Users')
			browser.text.should include('List of Tickets')
			browser.text.should include('List of my Tickets')
			browser.text.should include('Search')
			browser.text.should include('List of Buses')
		end
	end
	describe "Driver checking functionality" do
		it "should be possible to open list of passengers" do
			browser.link(:href => "/buses").when_present.click
			browser.link(:href => "/buses/1").when_present.click
			browser.button(:value => 'Show').when_present.click
			browser.text.should_not include('Gdansk')
			browser.text.should include('Warsaw')
			browser.text.should include('Ciechanow')
			browser.button(:value => 'Bought').exist?.should == true
		end
	end
end

