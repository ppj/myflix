class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      AppMailer.password_reset_link(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = "Invalid email address entered."
      redirect_to forgot_password_path
    end
  end

  def reset
    @user = User.find_by_token(params[:token])
    render :invalid_token unless @user
  end

  def update
    user = User.find_by_token(params[:token])
    if user
      user.update(password: params[:password], token: SecureRandom.urlsafe_base64)
      flash[:success] = "Password changed. Please login with the new password"
      redirect_to sign_in_path
    else
      render :invalid_token
    end
  end
end
