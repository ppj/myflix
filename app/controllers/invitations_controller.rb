class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge!(inviter: current_user))
    if @invitation.save
      AppMailer.invitation_email(@invitation).deliver
      flash[:success] = "Your invitation to #{@invitation.invitee_name} was sent"
      redirect_to new_invitation_path
    else
      flash.now[:danger] = "Please correct the errors in the inputs"
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invitee_name, :invitee_email, :message)
  end
end
