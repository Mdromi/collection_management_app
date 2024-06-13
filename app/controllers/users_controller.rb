class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def index
    @collections = Collection.includes(:user).order(items_count: :desc).limit(10)
    @items = Item.includes(:collection).order(created_at: :desc).limit(10)
  end
  
  def show
    @user = User.find(params[:id])
    @collections = @user.collections

    begin
      @pagy, @tickets = pagy(@user.tickets, items: 1)
    rescue Pagy::OverflowError
      total_pages = (@user.tickets.count.to_f / 10).ceil
      @pagy, @tickets = pagy(@user.tickets, items: 10, page: total_pages)
    end
  end
end
