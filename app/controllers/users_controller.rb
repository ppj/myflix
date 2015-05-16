class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "You have successfully registered. You can sign in now!"
      AppMailer.welcome_email(@user).deliver
      redirect_to sign_in_path
    else
      flash.now[:danger] = "Please fix the highlighted errors before continuing..."
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit!
  end
end
