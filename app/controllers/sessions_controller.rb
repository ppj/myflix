class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = 'You have successfully logged in.'
        redirect_to root_path
      else
        flash[:error] = 'Your account has been deactivated. Please contact support.'
        redirect_to sign_in_path
      end
    else
      flash.now[:danger] = 'The username or password you entered is incorrect.'
      render :new
    end
  end

  def destroy
    flash[:success] = 'You have logged out.' if logged_in?
    session[:user_id] = nil
    redirect_to root_path
  end
end
