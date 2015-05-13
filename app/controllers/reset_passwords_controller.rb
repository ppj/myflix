class ResetPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    AppMailer.password_reset_link(user).deliver
    redirect_to confirm_password_reset_path
  end
end
