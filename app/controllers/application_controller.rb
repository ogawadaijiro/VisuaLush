class ApplicationController < ActionController::Base
  def not_authenticated
    redirect_to new_user_session_path, alert: "Please login first"
  end
end
