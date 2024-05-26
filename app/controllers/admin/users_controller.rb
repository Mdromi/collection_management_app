class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:update, :destroy, :block, :unblock, :add_admin_role, :remove_admin_role]

  def index
    @users = User.all
  end

  def update
    if @user.update(user_params)
      flash[:success] = "User updated successfully."
    else
      flash[:error] = "Failed to update user."
    end
    redirect_to dashboard_path
  end

  def destroy
    if @user.destroy
      flash[:success] = "User deleted successfully."
    else
      flash[:error] = "Failed to delete user."
    end
    redirect_to dashboard_path
  end

  def block
    if @user.update(status: "blocked")
      flash[:success] = "User blocked successfully."
    else
      flash[:error] = "Failed to block user."
    end
    redirect_to dashboard_path
  end

  def unblock
    if @user.update(status: "active")
      flash[:success] = "User unblocked successfully."
    else
      flash[:error] = "Failed to unblock user."
    end
    redirect_to dashboard_path
  end

  def add_admin_role
    if @user.update(role: "admin")
      flash[:success] = "User promoted to admin successfully."
    else
      flash[:error] = "Failed to promote user to admin."
    end
    redirect_to dashboard_path
  end

  def remove_admin_role
    if @user.update(role: "regular")
      flash[:success] = "User demoted to regular successfully."
    else
      flash[:error] = "Failed to demote user to regular."
    end
    redirect_to dashboard_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:status, :role)
  end
end
