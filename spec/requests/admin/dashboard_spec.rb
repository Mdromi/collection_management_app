# spec/requests/admin/dashboard_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let!(:topics) { create_list(:topic, 3, user: user) }
  let!(:tags) { create_list(:tag, 3, user: user) }

  before do
    sign_in admin
  end

  describe "GET /dashboard" do
    context "when user is an admin" do
      it "returns http success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
      end

      it "assigns @users" do
        get dashboard_path
        expect(assigns(:users)).to include(user, admin)
      end

      it "assigns @topics" do
        get dashboard_path
        expect(assigns(:topics)).to match_array(topics)
      end

      it "assigns @tags" do
        get dashboard_path
        expect(assigns(:tags)).to match_array(tags)
      end

      it "paginates @users with default items per page" do
        create_list(:user, 3) # create more users to trigger pagination
        get dashboard_path
        expect(assigns(:pagy)).to be_a(Pagy)
        expect(assigns(:users).count).to eq(2) # Default items per page
      end

      it "rescues from Pagy::OverflowError and assigns @users with fallback pagination" do
        get dashboard_path, params: { page: 100 } # Assuming a page number that exceeds total pages
        expect(assigns(:pagy)).to be_a(Pagy)
        expect(assigns(:users).count).to be <= 10
      end
    end

    context "when user is not an admin" do
      before do
        sign_out admin
        sign_in user
      end

      it "redirects to root path with alert" do
        get dashboard_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to access this page.")
      end
    end

    context "when user is not authenticated" do
      before do
        sign_out admin
      end

      it "redirects to the sign in page" do
        get dashboard_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
