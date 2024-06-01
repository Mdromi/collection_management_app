class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @collection = Collection.find(params[:collection_id])
    @item = @collection.items.find(params[:item_id])
    @like = @item.likes.build(user: current_user)

    if @like.save
      redirect_to collection_item_path(@collection, @item), notice: "Item liked successfully."
    else
      redirect_to collection_item_path(@collection, @item), alert: "Failed to like item."
    end
  end

  def destroy
    @collection = Collection.find(params[:collection_id])
    @item = @collection.items.find(params[:item_id])
    @like = @item.likes.find_by(user_id: current_user.id) # Ensure finding like by user_id

    if @like&.destroy
      redirect_to collection_item_path(@collection, @item), notice: "Item unliked successfully."
    else
      redirect_to collection_item_path(@collection, @item), alert: "Failed to unlike item."
    end
  end
end
