class CollectionsController < ApplicationController
  include ImageUploadable

  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @collections = Collection.includes(:user).all
  end

  def show
    @collection = Collection.find(params[:id])
  end

  def new
    @collection = current_user.collections.build
  end

  def create
    @collection = current_user.collections.build(collection_params.except(:custom_fields))
    @collection.custom_fields = transform_custom_fields(collection_params[:custom_fields])

    if params[:collection][:image].present?
      encoded_image = Base64.strict_encode64(params[:collection][:image].read)
      Rails.logger.info "Encoded image: #{encoded_image[0..30]}..."
      cloudinary_response = upload_image_to_cloudinary(encoded_image)

      if cloudinary_response && cloudinary_response["secure_url"]
        @collection.image = cloudinary_response["secure_url"]
        flash.now[:notice] = "Image uploaded successfully."
      else
        flash.now[:alert] = "Failed to upload image to Cloudinary"
        render :new
        return
      end
    end

    if @collection.save
      redirect_to @collection, notice: "Collection was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    @collection = Collection.find(params[:id])

    # Transform the new custom fields
    new_custom_fields = transform_custom_fields(collection_params[:custom_fields])
    @collection.custom_fields = new_custom_fields

    # Handle image upload if present
    if params[:collection][:image].present?
      encoded_image = Base64.strict_encode64(params[:collection][:image].read)
      Rails.logger.info "Encoded image: #{encoded_image[0..30]}..."
      cloudinary_response = upload_image_to_cloudinary(encoded_image)
      Rails.logger.info "Cloudinary response: #{cloudinary_response}"

      if cloudinary_response && cloudinary_response["secure_url"]
        delete_image_from_cloudinary(@collection.image) if @collection.image.present?
        @collection.image = cloudinary_response["secure_url"]
        flash.now[:notice] = "Image uploaded successfully."
      else
        flash.now[:alert] = "Failed to upload image to Cloudinary"
        render :edit
        return
      end
    end

    if @collection.update(collection_params.except(:custom_fields, :image))
      redirect_to @collection, notice: "Collection was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @collection = Collection.find(params[:id])

    # Delete the image from Cloudinary if it exists
    if @collection.image.present?
      delete_image_from_cloudinary(@collection.image)
    end

    if @collection.destroy
      redirect_to user_profile_path, notice: "Collection was successfully destroyed."
    else
      redirect_to user_profile_path, alert: "Failed to destroy collection."
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to collections_path, alert: "Collection not found."
  end

  def collection_params
    params.require(:collection).permit(:name, :topic, :image, :description, custom_fields: [:label, :type])
  end

  def transform_custom_fields(custom_fields)
    return {} unless custom_fields

    custom_fields.each_with_object({}) do |field, result|
      result[field[:label]] = field[:type]
    end
  end

  def authorize_user!
    unless current_user == @collection.user || current_user.admin?
      redirect_to collections_path, alert: "You are not authorized to perform this action."
    end
  end
end
