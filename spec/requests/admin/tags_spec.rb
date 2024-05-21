require 'rails_helper'

RSpec.describe Admin::TagsController, type: :request do
  let(:admin_user) { FactoryBot.create(:user, role: 'admin') }
  let(:regular_user) { FactoryBot.create(:user) }

  describe "GET /admin/tags" do
    it "renders the index template" do
      sign_in admin_user
      get admin_tags_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  describe "GET /admin/tags/new" do
    it "renders the new template" do
      sign_in admin_user
      get new_admin_tag_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /admin/tags" do
    context "with valid parameters" do
      it "creates a new tag" do
        sign_in admin_user
        expect {
          post admin_tags_path, params: { tag: { name: "New Tag" } }
        }.to change(Tag, :count).by(1)
        expect(response).to redirect_to(admin_tags_path)
        expect(flash[:notice]).to eq("Tag created successfully.")
      end
    end

    context "with invalid parameters" do
      it "does not create a new tag" do
        sign_in admin_user
        expect {
          post admin_tags_path, params: { tag: { name: "" } }
        }.to_not change(Tag, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  # Similarly, you can write tests for edit, update, and destroy actions
end
