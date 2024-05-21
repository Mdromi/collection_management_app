class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :load_data, only: [:index]

  def index
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
  end

  def load_data
    @users = User.all
    @topics = Topic.all
    @tags = Tag.all
  end
end
