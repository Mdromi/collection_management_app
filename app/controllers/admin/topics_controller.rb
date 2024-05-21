class Admin::TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    # @topics = Topic.all
    @topics = Topic.includes(:tags).all
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      redirect_to dashboard_topics_path, notice: "Topic created successfully."
    else
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update(topic_params)
      redirect_to dashboard_topics_path, notice: "Topic updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to dashboard_topics_path, notice: "Topic deleted successfully."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
  end

  def topic_params
    params.require(:topic).permit(:name)
  end
end
