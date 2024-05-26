class Admin::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @tags = Tag.includes(:user).all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = current_user.tags.new(tag_params)
    if @tag.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append("tags", @tag) }
        format.html { redirect_to dashboard_path, notice: "Tag created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("tag-form", partial: "form", locals: { tag: @tag }) }
        format.html { render :new }
      end
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to dashboard_path, notice: "Tag updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to dashboard_path, notice: "Tag deleted successfully."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
