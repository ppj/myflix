class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You are not authorized to do that."
      redirect_to home_path
    end
  end
end
