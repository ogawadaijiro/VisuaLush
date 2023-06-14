class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create show edit update]
  before_action :set_user, only: %i[show edit update destroy]
  # User registration
  def new
    @user = User.new
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit;end

  def update
    if @user.update(user_params)
      flash[:notice] = "Successfully updated user."
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    # If the user is saved successfully than respond with json data format.
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to root_path
    else
      render 'new'
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :profile)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
