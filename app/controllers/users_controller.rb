class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

  def destroy

    if User.find(params[:id])==current_user && current_user.admin?
      flash[:error] = "You cannot delete yourself"
      redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  def new
    if current_user != nil
      redirect_to(root_path)
    else
      @user = User.new
      @title = "Register"
    end
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    if current_user != nil
      redirect_to(root_path)
    else
      @user = User.new(params[:user])
      if @user.save
        log_in @user
        flash[:success] = "Welcome to the BusCompanySupport!"
        redirect_to @user
      else
        @title = "Register"
        @user.password.clear
        @user.password_confirmation.clear
        render 'new'
      end
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

