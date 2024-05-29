class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection_and_item
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @item.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to collection_item_path(@collection, @item), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to collection_item_path(@collection, @item), notice: 'Comment was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_collection_and_item
    @collection = Collection.find(params[:collection_id])
    @item = @collection.items.find(params[:item_id])
  end

  def set_comment
    @comment = @item.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
