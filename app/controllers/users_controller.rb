class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy followings followers]
  # User registration
  def new
    @user = User.new
  end

  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(9)
  end

  def edit;end

  def followings
    @users = @user.followings
  end

  def followers
    @users = @user.followers
  end

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
