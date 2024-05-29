class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @collection = Collection.find(params[:collection_id])
    @item = @collection.items.find(params[:item_id])
    @like = @item.likes.build(user: current_user)

    if @like.save
      redirect_back fallback_location: root_path, notice: "Item liked successfully."
    else
      redirect_back fallback_location: root_path, alert: "Failed to like item."
    end
  end

  def destroy
    @collection = Collection.find(params[:collection_id])
    @item = @collection.items.find(params[:item_id])
    @like = @item.likes.find_by(user: current_user)

    if @like.destroy
      redirect_back fallback_location: root_path, notice: "Item unliked successfully."
    else
      redirect_back fallback_location: root_path, alert: "Failed to unlike item."
    end
  end
end
