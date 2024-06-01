require "rails_helper"

RSpec.describe LikesController, type: :controller do
  render_views
  let(:user) { create(:user) }
  let(:collection) { create(:collection) }
  let(:item) { create(:item, collection: collection) }
  let!(:like) { create(:like, item: item, user: user) }

  describe "POST #create" do
    context "when user is authenticated" do
      before { sign_in user }

      it "creates a like for the item" do
        post :create, params: { collection_id: collection.id, item_id: item.id }
        expect(response).to redirect_to(collection_item_path(collection, item))
        expect(flash[:notice]).to eq("Item liked successfully.")
      end
    end

    context "when user is not authenticated" do
      it "redirects to sign in page" do
        post :create, params: { collection_id: collection.id, item_id: item.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is authenticated" do
      before { sign_in user }

      it "destroys the like for the item" do
        delete :destroy, params: { collection_id: collection.id, item_id: item.id, id: like.id }
        expect(response).to redirect_to(collection_item_path(collection, item))
        expect(flash[:notice]).to eq("Item unliked successfully.")
      end
    end

    context "when user is not authenticated" do
      it "redirects to sign in page" do
        delete :destroy, params: { collection_id: collection.id, item_id: item.id, id: like.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
