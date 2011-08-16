require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
  response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
  response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
  response.should have_selector('title', :content => "Help")
  end

  it "should have a signup page at '/register'" do
    get '/register'
    response.should have_selector('title', :content => "Register")
  end
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Register"
    response.should have_selector('title', :content => "Register")
  end

  describe "when not logged in" do
    it "should have a login link" do
      visit root_path
      response.should have_selector("a", :href => log_in_path, :content =>"Log in")
    end
  end

  describe "when logged in" do

    before(:each) do
      @user = Factory(:user)
      visit log_in_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a log out link" do
      visit root_path
      response.should have_selector("a", :href => log_out_path, :content => "Log out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content => "Profile")
    end
  end
end

