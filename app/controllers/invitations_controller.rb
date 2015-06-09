class InvitationsController < ApplicationController
  before_action :require_user

  def create
    AppMailer.invitation(params[:name], params[:email], params[:message]).deliver
    flash[:success] = "Invitation sent successfully"
    redirect_to home_path
  end
end
