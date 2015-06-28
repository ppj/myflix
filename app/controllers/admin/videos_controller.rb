class Admin::VideosController < ApplicationController
  before_action :require_admin
end
