class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def require_admin
    access_denied "You are not authorized to do that." unless current_user.admin?
  end

end
