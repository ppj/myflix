class ResetPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      AppMailer.password_reset_link(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = "Invalid email address entered."
      redirect_to reset_password_path
    end
  end
end
