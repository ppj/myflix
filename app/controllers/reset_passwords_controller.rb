class ResetPasswordsController < ApplicationController
  def show
    @user = User.find_by(token: params[:id])
    redirect_to expired_token_path unless @user
  end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.update(password: params[:password], token: nil)
      flash[:success] = "Password changed. Please login with the new password"
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end
