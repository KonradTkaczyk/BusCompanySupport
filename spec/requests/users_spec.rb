require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit register_path
          fill_in "Name", :with => ""
          fill_in "Surname", :with => ""
          fill_in "Email", :with => ""
          fill_in "Postal Code", :with => ""
          fill_in "Password", :with => ""
          fill_in "Password confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit register_path
          fill_in "Name", :with => "Example User"
          fill_in "Surname", :with => "Example"
          fill_in "Email", :with => "user@example.com"
          fill_in "Postal Code", :with => "99-999"
          fill_in "Password", :with => "foobar"
          fill_in "Password confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
          :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "log in/out" do

    describe "failure" do
      it "should not log a user in" do
        user = Factory(:user)
        user.password = "invalid" #invalid password addedd to simulate typing wrong password
        integration_log_in(user)
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "Success" do
      it "should log a user in and out" do
        integration_log_in(Factory(:user))
        controller.should be_logged_in
        click_link "Log out"
        controller.should_not be_logged_in
      end
    end
  end
end

