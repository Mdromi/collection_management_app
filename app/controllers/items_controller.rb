class ItemsController < ApplicationController
  include ImageUploadable

  before_action :set_collection
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # GET /collections/:collection_id/items
  def index
    @items = @collection.items
  end

  # GET /collections/:collection_id/items/1
  def show
    @user = @item.collection.user
    load_custom_fields
  end

  # GET /collections/:collection_id/items/new
  def new
    @item = @collection.items.build
    @item.item_custom_field_values.build
    load_custom_fields
  end

  # POST /collections/:collection_id/items
  def create
    @item = @collection.items.build(item_params.except(:custom_field_values_attributes))
    @item.tags = params[:tags] if params[:tags].present?

    handle_image_upload

    if @item.save
      save_custom_field_values
      redirect_to [@collection, @item], notice: "Item was successfully created."
    else
      load_custom_fields
      render :new
    end
  end

  # GET /collections/:collection_id/items/1/edit
  def edit
    load_custom_fields
  end

  # PATCH/PUT /collections/:collection_id/items/1
  def update
    handle_image_upload

    if @item.update(item_params.except(:custom_field_values_attributes, :image))
      save_custom_field_values
      redirect_to [@collection, @item], notice: "Item was successfully updated."
    else
      load_custom_fields
      render :edit
    end
  end

  # DELETE /collections/:collection_id/items/1
  def destroy
    @item.destroy
    redirect_to collection_items_path(@collection), notice: "Item was successfully destroyed."
  end

  def like
    # Implement like functionality
  end


  private

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end

  def set_item
    @item = @collection.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :image, :tags, custom_field_values_attributes: [:value, :custom_field_id])
  end

  def load_custom_fields
    @custom_fields = @collection.custom_fields
  end

  def authorize_user!
    unless current_user == @item.collection.user || current_user.admin?
      redirect_to collection_items_path(@collection), alert: "You are not authorized to perform this action."
    end
  end

  def handle_image_upload
    if params[:item][:image].present?
      encoded_image = Base64.strict_encode64(params[:item][:image].read)
      cloudinary_response = upload_image_to_cloudinary(encoded_image)

      if cloudinary_response && cloudinary_response["secure_url"]
        delete_image_from_cloudinary(@item.image) if action_name == "update" && @item.image.present?
        @item.image = cloudinary_response["secure_url"]
        flash.now[:notice] = "Image uploaded successfully."
      else
        flash.now[:alert] = "Failed to upload image to Cloudinary"
        render action_name == "create" ? :new : :edit
        return
      end
    end
  end

  def save_custom_field_values
    return unless params[:item][:custom_field_values_attributes].present?

    params[:item][:custom_field_values_attributes].each do |_, value_params|
      custom_field_value = @item.item_custom_field_values.new(
        value: value_params[:value],
        custom_field_id: value_params[:custom_field_id],
      )
      custom_field_value.save
    end
  end
end
