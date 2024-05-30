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
    @q_users = User.ransack(params[:q])
    @q_topics = Topic.includes(:user).ransack(params[:q])
    @q_tags = Tag.includes(:user).ransack(params[:q])
    @users = @q_users.result(distinct: true)
    @topics = @q_topics.result(distinct: true).order(created_at: :desc)
    @tags = @q_tags.result(distinct: true).order(created_at: :desc)
  end
end
