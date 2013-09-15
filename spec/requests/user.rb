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
		browser.text_field(:name => 'session[email]').when_present.set("user@bcs.org")
		browser.text_field(:name => 'session[password]').when_present.set("foobar")
		browser.button(:value => "Log in").when_present.click
	end

	describe "Main page buttons" do
		it "should consist of the main menu page" do
			sleep 2
			browser.text.should_not include('List of Users')
			browser.text.should include('List of Tickets')
			browser.text.should include('List of my Tickets')
			browser.text.should include('Search')
			browser.text.should_not include('List of Buses')
		end
		it "should allow to see all tickets" do
			browser.link(:href => "/tickets").when_present.click
			browser.table(:id, 'Index of tickets')
		end
		describe "Search for tickets and reservation" do
			before(:each) do
				browser.link(:href => "/ticket/search").when_present.click
			end
			it "should allow to see reserved ticket in all My tickets" do
				browser.select_list(:id => 'ticket_city_from').when_present.select('Radom')
				browser.select_list(:id => 'ticket_city_to').when_present.select('Szczecin')
				browser.button(:type => 'submit').when_present.click
				(0..3).each { |x| browser.li(:class => "seat row-#{rand(2)} col-#{rand(5)}", :index  => x).when_present.click }
				browser.button(:value => 'Reserve selected seats').when_present.click
				browser.alert.ok
			end
		end
	end
end

