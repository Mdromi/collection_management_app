class CollectionsController < ApplicationController
  include ImageUploadable

  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :load_users, only: [:new, :create, :edit, :update]

  def index
    @collections = Collection.includes(:user).all
  end

  def show
    load_custom_fields
    @items = @collection.items
    @q = @items.ransack(params[:q])

    if params[:q] && params[:q][:s]
      custom_sort_params = params[:q][:s]
      if custom_sort_params.include?("item_custom_field_values_")
        custom_field_id, order = custom_sort_params.match(/item_custom_field_values_(\d+)_value (\w+)/).captures
        @items = @items.joins(:item_custom_field_values)
                       .where(item_custom_field_values: { custom_field_id: custom_field_id })
                       .order("item_custom_field_values.value #{order}")
      else
        @items = @q.result(distinct: true)
      end
    else
      @items = @q.result(distinct: true)
    end

    # Ensure @items is paginated only after all ActiveRecord queries are done
    begin
      @pagy, @items = pagy(@items, items: 10) # Adjust per page as needed
    rescue Pagy::OverflowError
      # Handle overflow error (e.g., redirect to the last page)
      @pagy, @items = pagy(@items, items: 10, page: @pagy.last)
    end

    @items_with_joined_data = @items.map do |item|
      custom_fields = CustomField.where(collection_id: item.collection_id)
      item_custom_field_values = ItemCustomFieldValue.where(item_id: item.id)

      joined_data = custom_fields.joins(:item_custom_field_values)
                                 .where(item_custom_field_values: { item_id: item.id })
                                 .select("custom_fields.label AS custom_field_label, item_custom_field_values.value AS custom_field_value")

      { item: item, joined_data: joined_data }
    end
  end

  def new
    @collection = Collection.new
    @collection.custom_fields.build # Build an initial custom field for the form
  end

  def create
    if current_user.admin? && collection_params[:user_id].present?
      @collection = Collection.new(collection_params.except(:custom_fields))
    else
      @collection = current_user.collections.build(collection_params.except(:user_id, :custom_fields))
    end

    handle_image_upload

    if @collection.save
      # Extract custom field data and create CustomField records
      create_custom_fields(@collection, collection_params[:custom_fields]) if collection_params[:custom_fields].present?

      redirect_to @collection, notice: "Collection was successfully created."
    else
      render :new
    end
  end

  def update
    handle_image_upload

    Rails.logger.debug "Received parameters: #{collection_params.inspect}"

    if @collection.update(collection_params.except(:custom_fields, :image))
      # Update existing custom fields
      update_custom_fields(@collection, collection_params[:custom_fields]) if collection_params[:custom_fields].present?

      Rails.logger.debug "Collection attributes after update: #{@collection.attributes}"

      redirect_to @collection, notice: "Collection was successfully updated."
    else
      render :edit
    end
  end

  def edit
    @collection.custom_fields.build if @collection.custom_fields.empty? # Build an initial custom field if none exist
  end

  def destroy
    delete_image_from_cloudinary(@collection.image) if @collection.image.present?

    if @collection.destroy
      redirect_to user_profile_path, notice: "Collection was successfully destroyed."
    else
      redirect_to user_profile_path, alert: "Failed to destroy collection."
    end
  end

  def delete_custom_field
    custom_field = CustomField.find(params[:custom_field_id])
    collection = custom_field.collection

    if custom_field.destroy
      respond_to do |format|
        format.html { redirect_to edit_collection_path(collection), notice: "Custom field was successfully deleted." }
        format.js { render layout: false } # Handle JavaScript response for remote deletion
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_collection_path(collection), alert: "Failed to delete custom field." }
        format.js { render layout: false, status: :unprocessable_entity } # Handle JavaScript response for failure
      end
    end
  end

  def export_csv
    @collection = Collection.find(params[:id])
    respond_to do |format|
      format.csv do
        send_data @collection.items.to_csv, filename: "collection_items.csv"
      end
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to collections_path, alert: "Collection not found."
  end

  def collection_params
    params.require(:collection).permit(:name, :topic, :image, :description, :user_id, custom_fields: [:label, :type, :id], q: [:s])
  end

  def authorize_user!
    unless current_user == @collection.user || current_user.admin?
      redirect_to collections_path, alert: "You are not authorized to perform this action."
    end
  end

  def load_users
    @users = User.all if current_user.admin?
  end

  def load_custom_fields
    @custom_fields ||= @collection.custom_fields
  end

  def create_custom_fields(collection, custom_fields)
    custom_fields.each do |field_params|
      collection.custom_fields.create(label: field_params[:label], data_type: field_params[:type])
    end
  end

  def update_custom_fields(collection, custom_fields_params)
    custom_fields_params.each do |field_params|
      if field_params[:id].present?
        # Update existing custom field if ID is present
        custom_field = collection.custom_fields.find_by(id: field_params[:id])
        next unless custom_field # Skip if custom field doesn't exist

        custom_field.update(label: field_params[:label], data_type: field_params[:type])
      else
        # Create new custom field if ID is not present
        collection.custom_fields.create(label: field_params[:label], data_type: field_params[:type])
      end
    end
  end

  def handle_image_upload
    if params[:collection][:image].present?
      encoded_image = Base64.strict_encode64(params[:collection][:image].read)
      cloudinary_response = upload_image_to_cloudinary(encoded_image)

      if cloudinary_response && cloudinary_response["secure_url"]
        delete_image_from_cloudinary(@collection.image) if action_name == "update" && @collection.image.present?
        @collection.image = cloudinary_response["secure_url"]
        flash.now[:notice] = "Image uploaded successfully."
      else
        flash.now[:alert] = "Failed to upload image to Cloudinary"
        render action_name == "create" ? :new : :edit
        return
      end
    end
  end
end
