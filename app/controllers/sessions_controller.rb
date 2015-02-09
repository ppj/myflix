class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'You have successfully logged in.'
      redirect_to root_path
    else
      flash.now[:danger] = 'The username or password you entered is incorrect.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You have logged out.'
    redirect_to root_path
  end
end
