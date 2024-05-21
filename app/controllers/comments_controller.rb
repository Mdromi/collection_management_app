class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection
  before_action :set_item
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @item.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to collection_item_path(@collection, @item), notice: 'Comment was successfully created.'
    else
      redirect_to collection_item_path(@collection, @item), alert: 'Failed to create comment.'
    end
  end

  def destroy
    if @comment.destroy
      redirect_to collection_item_path(@collection, @item), notice: 'Comment was successfully destroyed.'
    else
      redirect_to collection_item_path(@collection, @item), alert: 'Failed to destroy comment.'
    end
  end

  private

  def set_collection
    @collection = Collection.includes(items: :comments).find(params[:collection_id])
  end

  def set_item
    @item = @collection.items.find(params[:item_id])
  end

  def set_comment
    @comment = @item.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
