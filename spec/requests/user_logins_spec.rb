require 'spec_helper'
require "watir-webdriver"

browser = Watir::Browser.new
location_of_BCS = "http://localhost"
port_of_BCS = "3000"
link_to_BCS = location_of_BCS + ":" + port_of_BCS

RSpec.configure do |config|
  config.after(:suite) { browser.close unless browser.nil? }
end

describe "Registering a new user" do
  browser.goto link_to_BCS + '/register'
  browser.text_field(:name => 'user[name]').set("Jan")
  browser.text_field(:name => 'user[surname]').set("Kowalski")
  browser.select_list(:name, 'user[birthday(1i)]').select("1986")
  browser.select_list(:name, 'user[birthday(2i)]').select("September")
  browser.select_list(:name, 'user[birthday(3i)]').select("20")
  browser.radio(:id, "user_gender_true").set
  browser.text_field(:name => 'user[city]').set("Kowalowo")
  browser.text_field(:name => 'user[address]').set("Kowalska 24")
  browser.text_field(:name => 'user[postalcode]').set("12-345")
  browser.text_field(:name => 'user[email]').set("proper_email@bcs.org")
  browser.text_field(:name => 'user[password]').set("foobar")
  browser.text_field(:name => 'user[password_confirmation]').set("foobar")

end

describe "Test the user functionalities" do
  before(:each) do #this will login user to the home page of the user
    browser.goto link_to_BCS + '/log_in'
    browser.text_field(:name => 'session[email]').set("user@bcs.org")
    browser.text_field(:name => 'session[password]').set("foobar")
    browser.button(:value => "Log in").click
  end

  describe "that we have 3 main buttons" do
    it "should consist of the main menu page" do
      browser.text.should include('List of Tickets')
      browser.text.should include('List of my Tickets')
      browser.text.should include('Search')
      browser.text.should_not include('List of Buses')
    end
    it "should allow to see all tickets" do

    end
  end
end

