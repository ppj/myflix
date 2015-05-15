class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_token
      AppMailer.password_reset_link(user).deliver
      render :confirm
    else
      flash[:danger] = "Invalid email address entered."
      redirect_to forgot_password_path
    end
  end
end
