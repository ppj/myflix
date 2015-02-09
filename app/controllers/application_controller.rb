class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?, :current_user

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    access_denied 'This action is restricted to registered users only. Please sign in/up.' unless logged_in?
  end

  def access_denied(msg)
    flash[:info] = msg
    redirect_to root_path
  end

end
