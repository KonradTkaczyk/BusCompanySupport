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


describe "Test the user functionalities" do
	before(:each) do #this will login user to the home page of the user
		browser.goto link_to_BCS + '/log_in'
		browser.text_field(:name => 'session[email]').set("user@bcs.org")
		browser.text_field(:name => 'session[password]').set("foobar")
		browser.button(:value => "Log in").click
	end

	describe "Main page buttons" do
		it "should consist of the main menu page" do
			browser.text.should_not include('List of Users')
			browser.text.should include('List of Tickets')
			browser.text.should include('List of my Tickets')
			browser.text.should include('Search')
			browser.text.should_not include('List of Buses')
		end
		it "should allow to see all tickets" do
			browser.link(:href => "/tickets").click
			browser.table(:id, 'Index of tickets')
		end
		it "should allow to see all My tickets" do

		end

		it "should allow to search for tickets" do

		end
	end

	describe "Search for the tickets" do

	end
end

