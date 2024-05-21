class Admin::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_tag, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to admin_tags_path, notice: "Tag created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to admin_tags_path, notice: "Tag updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy
    redirect_to admin_tags_path, notice: "Tag deleted successfully."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
