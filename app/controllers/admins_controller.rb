class AdminsController < ApplicationController
  before_action :require_admin

  def require_admin
    if logged_in?
      access_denied "This action is reserved for administrators only." unless current_user.admin?
    else
      require_user
    end
  end

end
