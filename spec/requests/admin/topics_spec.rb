require 'rails_helper'

RSpec.describe Admin::TopicsController, type: :request do
  let(:admin_user) { FactoryBot.create(:user, role: 'admin') }

  describe "GET /dashboard/topics" do
    it "renders the index template" do
      sign_in admin_user
      get dashboard_topics_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  # Write similar tests for other controller actions like new, create, edit, update, and destroy
end
