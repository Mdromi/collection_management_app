class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @users = User.with_attached_avatar.includes(:posts)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to dashboard_users_path, notice: "User updated successfully."
    else
      render :index
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to dashboard_users_path, notice: "User deleted successfully."
  end

  def block
    @user = User.find(params[:id])
    @user.update(blocked: true)
    redirect_to dashboard_users_path, notice: "User blocked successfully."
  end

  def unblock
    @user = User.find(params[:id])
    @user.update(blocked: false)
    redirect_to dashboard_users_path, notice: "User unblocked successfully."
  end

  def add_admin_role
    @user = User.find(params[:id])
    @user.update(role: "admin")
    redirect_to dashboard_users_path, notice: "Admin role added successfully."
  end

  def remove_admin_role
    @user = User.find(params[:id])
    @user.update(role: "regular")
    redirect_to dashboard_users_path, notice: "Admin role removed successfully."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "You are not authorized to access this page." unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:username, :email, :role)
  end
end
