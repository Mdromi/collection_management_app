class Admin::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "User updated successfully."
      redirect_to admin_users_path
    else
      flash[:error] = "Failed to update user."
      redirect_to admin_users_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User deleted successfully."
    else
      flash[:error] = "Failed to delete user."
    end
    redirect_to admin_users_path
  end

  def block
    @user = User.find(params[:id])
    @user.update(status: "blocked")
    redirect_to admin_users_path
  end

  def unblock
    @user = User.find(params[:id])
    @user.update(status: "active")
    redirect_to admin_users_path
  end

  def add_admin_role
    @user = User.find(params[:id])
    @user.update(role: "admin")
    redirect_to admin_users_path
  end

  def remove_admin_role
    @user = User.find(params[:id])
    @user.update(role: "regular")
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:status, :role)
  end
end
