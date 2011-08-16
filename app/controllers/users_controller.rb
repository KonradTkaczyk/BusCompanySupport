class UsersController < ApplicationController

  def new
    @user = User.new
    @title = "Register"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Register"
      @user.password.clear
      @user.password_confirmation.clear
      render 'new'
    end
  end
end

