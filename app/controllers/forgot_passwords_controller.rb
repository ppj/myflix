class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      AppMailer.password_reset_link(user).deliver
      render :confirm
    else
      flash[:danger] = "Invalid email address entered."
      redirect_to forgot_password_path
    end
  end
end
