require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:collection) { create(:collection, user: user) }
  let(:item) { create(:item, collection: collection) }
  let(:comment) { create(:comment, item: item, user: user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    let(:valid_attributes) { { content: "This is a new comment." } }
    let(:invalid_attributes) { { content: "" } }

    context "with valid parameters" do
      it "creates a new comment" do
        expect {
          post :create, params: { collection_id: collection.id, item_id: item.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the item page" do
        post :create, params: { collection_id: collection.id, item_id: item.id, comment: valid_attributes }
        expect(response).to redirect_to(collection_item_path(collection, item))
      end

      it "renders JSON response for the newly created comment" do
        post :create, params: { collection_id: collection.id, item_id: item.id, comment: valid_attributes, format: :json }
        expect(response.content_type).to include("application/json")
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new comment" do
        expect {
          post :create, params: { collection_id: collection.id, item_id: item.id, comment: invalid_attributes }
        }.to change(Comment, :count).by(0)
      end

      it "redirects to the item page with an alert" do
        post :create, params: { collection_id: collection.id, item_id: item.id, comment: invalid_attributes }
        expect(response).to redirect_to(collection_item_path(collection, item))
        expect(flash[:alert]).to eq('Failed to create comment.')
      end

      it "renders JSON response with errors" do
        post :create, params: { collection_id: collection.id, item_id: item.id, comment: invalid_attributes, format: :json }
        expect(response.content_type).to include("application/json")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      comment # to ensure the comment is created before the expect block
      expect {
        delete :destroy, params: { collection_id: collection.id, item_id: item.id, id: comment.id }
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the item page" do
      delete :destroy, params: { collection_id: collection.id, item_id: item.id, id: comment.id }
      expect(response).to redirect_to(collection_item_path(collection, item))
    end

    it "renders JSON response with no content" do
      delete :destroy, params: { collection_id: collection.id, item_id: item.id, id: comment.id, format: :json }
      expect(response).to have_http_status(:no_content)
    end
  end
end
