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

describe "Test new user registration" do
	before(:each) do #this will log out user to the home page
		if browser.link(:href => '/log_out').exists?
			browser.link(:href => '/log_out').click
		end
	end
	it "should allow to register this user" do
		browser.goto link_to_BCS + '/register'
		browser.text_field(:name => 'user[name]').when_present.set("Jan")
		browser.text_field(:name => 'user[surname]').when_present.set("Kowalski")
		browser.select_list(:name, 'user[birthday(1i)]').when_present.select("1986")
		browser.select_list(:name, 'user[birthday(2i)]').when_present.select("September")
		browser.select_list(:name, 'user[birthday(3i)]').when_present.select("20")
		browser.radio(:id, "user_gender_true").when_present.set
		browser.text_field(:name => 'user[city]').when_present.set("Kowalowo")
		browser.text_field(:name => 'user[address]').when_present.set("Kowalska 24")
		browser.text_field(:name => 'user[postalcode]').when_present.set("12-345")
		browser.text_field(:name => 'user[email]').when_present.set("proper_email@bcs.org")
		browser.text_field(:name => 'user[password]').when_present.set("foobar")
		browser.text_field(:name => 'user[password_confirmation]').when_present.set("foobar")
		browser.button(:value => 'Register').when_present.click
		browser.text.should include('Welcome to the BusCompanySupport!')
		browser.text.should include('List of my Tickets')
	end
	it "should not allow to register this user" do
		browser.goto link_to_BCS + '/register'
		browser.text_field(:name => 'user[name]').when_present.set("JanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJanJ")
		browser.text_field(:name => 'user[surname]').when_present.set("Kowalski")
		browser.select_list(:name, 'user[birthday(1i)]').when_present.select("1986")
		browser.select_list(:name, 'user[birthday(2i)]').when_present.select("September")
		browser.select_list(:name, 'user[birthday(3i)]').when_present.select("20")
		browser.radio(:id, "user_gender_true").when_present.set
		browser.text_field(:name => 'user[city]').when_present.set("Kowalowo")
		browser.text_field(:name => 'user[address]').when_present.set("Kowalska 24")
		browser.text_field(:name => 'user[postalcode]').when_present.set("122345")
		browser.text_field(:name => 'user[email]').when_present.set("inproper_email")
		browser.text_field(:name => 'user[password]').when_present.set("foobar")
		browser.text_field(:name => 'user[password_confirmation]').when_present.set("missConfirmedPassword")
		browser.button(:value => 'Register').when_present.click
		browser.text.should_not include('Welcome to the BusCompanySupport!')
		browser.text.should_not include('/ticket/reserved_index')
		browser.text.should include('Name is too long (maximum is 50 characters)')
		browser.text.should include('Email is invalid')
		browser.text.should include('Password doesn\'t match confirmation')
		browser.text.should include('Postalcode should be in format xx-xxx, where x is digit')
	end
end

describe "Test the admin functionalities" do
	before(:each) do
		browser.goto link_to_BCS + '/log_in'
		browser.text_field(:name => 'session[email]').when_present.set("admin@bcs.org")
		browser.text_field(:name => 'session[password]').when_present.set("foobar")
		browser.button(:value => "Log in").when_present.click
	end

	describe "Main page buttons" do
		it "should consist of the main menu page" do
			browser.text.should include('List of Users')
			browser.text.should include('List of Tickets')
			browser.text.should include('List of my Tickets')
			browser.text.should include('Search')
			browser.text.should include('List of Buses')
		end
	end
	describe "Controlling of users by admin" do
		it "should be possible to delete newly created user" do
			browser.link(:href => "/users").click
			begin
				if browser.link(:title => "Delete Jan").exist?
					browser.link(:title => "Delete Jan").click
					break
				end
				browser.link(:class => "next_page").click
			end while not browser.link(:class => "next_page disabled").exist?
			if 'Are You sure do You want to delete?' == browser.alert.text
				browser.alert.ok
			end
			browser.text.should include('User destroyed.')
		end
	end
end

