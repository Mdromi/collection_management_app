require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, role: 'admin') }
  let(:regular_user) { FactoryBot.create(:user) }

  describe "GET #index" do
    it "renders the index template" do
      sign_in admin_user
      get :index
      expect(response).to render_template("index")
    end

    it "assigns all users as @users" do
      sign_in admin_user
      users = FactoryBot.create_list(:user, 3)
      get :index
      expect(assigns(:users)).to eq(users)
    end
  end

  describe "PATCH #update" do
    it "updates the user" do
      sign_in admin_user
      user = FactoryBot.create(:user)
      patch :update, params: { id: user.id, user: { username: "new_username" } }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(user.reload.username).to eq("new_username")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the user" do
      sign_in admin_user
      user = FactoryBot.create(:user)
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(User.exists?(user.id)).to be_falsy
    end
  end

  describe "PATCH #block" do
    it "blocks the user" do
      sign_in admin_user
      user = FactoryBot.create(:user)
      patch :block, params: { id: user.id }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(user.reload.blocked).to eq(true)
    end
  end

  describe "PATCH #unblock" do
    it "unblocks the user" do
      sign_in admin_user
      user = FactoryBot.create(:user, blocked: true)
      patch :unblock, params: { id: user.id }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(user.reload.blocked).to eq(false)
    end
  end

  describe "PATCH #add_admin_role" do
    it "adds admin role to the user" do
      sign_in admin_user
      user = FactoryBot.create(:user, role: "regular")
      patch :add_admin_role, params: { id: user.id }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(user.reload.admin?).to eq(true)
    end
  end

  describe "PATCH #remove_admin_role" do
    it "removes admin role from the user" do
      sign_in admin_user
      user = FactoryBot.create(:user, role: "admin")
      patch :remove_admin_role, params: { id: user.id }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(user.reload.admin?).to eq(false)
    end
  end
end
