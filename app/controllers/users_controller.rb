class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_invited
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(fullname: invitation.invitee_name, email: invitation.invitee_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      handle_invitation
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

  def handle_invitation
    if params[:invitation_token]
      invitation = Invitation.find_by(token: params[:invitation_token])
      invitation.inviter.follow(@user)
      @user.follow(invitation.inviter)
      invitation.update_column(:token, nil)
    end
  end
end
