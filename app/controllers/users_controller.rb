class UsersController < ApplicationController

  def new
    @title = "Register"
  end

  def show
    @user = User.find(params[:id])
  end

end

