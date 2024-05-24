class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    # @collections = Collection.all
    @collections = Collection.includes(:items).all
  end

  def show
    # @items = @collection.items
    @collection = Collection.includes(:items).find(params[:id])
  end

  def new
    @collection = current_user.collections.build
  end

  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      redirect_to @collection, notice: "Collection was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @collection.update(collection_params)
      redirect_to @collection, notice: "Collection was successfully updated."
    else
      render :edit
    end
  end

  def update2
    @collection = Collection.find(params[:id])
    if params[:collection][:image].present?
      encoded_image = Base64.strict_encode64(params[:collection][:image].read)
      ImageUploadJob.perform_later(@collection.class.name, @collection.id, :image, encoded_image)
      flash[:success] = "Image update is being processed."
    else
      flash[:error] = "Image cannot be blank."
    end
    redirect_to @collection
  end

  def destroy
    @collection.destroy
    redirect_to collections_url, notice: "Collection was successfully destroyed."
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to collections_path, alert: "Collection not found."
  end

  def collection_params
    params.require(:collection).permit(:name, :description, :topic, :image)
  end

  def authorize_user!
    unless current_user == @collection.user || current_user.admin?
      redirect_to collections_path, alert: "You are not authorized to perform this action."
    end
  end
end
