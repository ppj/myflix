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
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.perform(user: @user,
                                stripe_token: params[:stripeToken],
                                invitation_token: params[:invitation_token])
    if result.successful?
      flash[:success] = "You have successfully registered. You can sign in now!"
      redirect_to sign_in_path
    else
      flash.now[:danger] = result.error_message
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
