class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def index
    @collections = Collection.includes(:user).order(items_count: :desc).limit(10)
  end
  
  def show
    @user = User.find(params[:id])
    @collections = @user.collections
  end
end
