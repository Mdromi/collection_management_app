class ItemsController < ApplicationController
  before_action :set_collection
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @items = @collection.items.includes(:comments)
  end

  def show
  end

  def new
    @item = @collection.items.build
  end

  def create
    @item = @collection.items.build(item_params)
    if @item.save
      redirect_to collection_item_path(@collection, @item), notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to collection_item_path(@collection, @item), notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to collection_items_path(@collection), notice: 'Item was successfully destroyed.'
  end

  private

  def set_collection
    @collection = Collection.includes(:items).find(params[:collection_id])
  end

  def set_item
    @item = @collection.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :image, :tag_list)
  end

  def authorize_user!
    unless current_user == @collection.user || current_user.admin?
      redirect_to collection_items_path(@collection), alert: 'You are not authorized to perform this action.'
    end
  end
end
