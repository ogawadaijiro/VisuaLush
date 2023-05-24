class UsersController < ApplicationController
  # User registration
  def new
    @user = User.new
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
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
