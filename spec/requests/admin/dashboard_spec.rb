require "rails_helper"

RSpec.describe Admin::DashboardController, type: :controller do
  describe "GET #index" do
    context "when user is an admin" do
      let(:admin_user) { FactoryBot.create(:user, admin: true) }

      before do
        sign_in admin_user
        get :index
      end

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "assigns users, topics, and tags" do
        expect(assigns(:users)).to eq(User.all)
        expect(assigns(:topics)).to eq(Topic.all)
        expect(assigns(:tags)).to eq(Tag.all)
      end
    end

    context "when user is not an admin" do
      let(:regular_user) { FactoryBot.create(:user, admin: false) }

      before do
        sign_in regular_user
        get :index
      end

      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end

      it "displays an alert message" do
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end
  end
end
