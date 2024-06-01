require "rails_helper"

RSpec.describe ItemsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:collection) { create(:collection, user: user) }
  let(:item) { create(:item, collection: collection) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index, params: { collection_id: collection.id }
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { collection_id: collection.id, id: item.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new, params: { collection_id: collection.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        name: "New Item",
        description: "Item description",
      }
    end

    it "creates a new item" do
      expect {
        post :create, params: { collection_id: collection.id, item: valid_attributes }
      }.to change(Item, :count).by(1)
    end

    it "redirects to the item's page" do
      post :create, params: { collection_id: collection.id, item: valid_attributes }
      expect(response).to redirect_to(collection_item_path(collection, Item.last))
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { collection_id: collection.id, id: item.id }
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    let(:new_attributes) do
      {
        name: "Updated Item",
        description: "Updated description",
      }
    end

    it "updates the item" do
      patch :update, params: { collection_id: collection.id, id: item.id, item: new_attributes }
      item.reload
      expect(item.name).to eq("Updated Item")
      expect(item.description).to eq("Updated description")
    end

    it "redirects to the item's page" do
      patch :update, params: { collection_id: collection.id, id: item.id, item: new_attributes }
      expect(response).to redirect_to(collection_item_path(collection, item))
    end
  end

  describe "DELETE #destroy" do
    it "destroys the item" do
      item # to create the item before the expect block
      expect {
        delete :destroy, params: { collection_id: collection.id, id: item.id }
      }.to change(Item, :count).by(-1)
    end

    it "redirects to the collection's items list" do
      delete :destroy, params: { collection_id: collection.id, id: item.id }
      expect(response).to redirect_to(collection_items_path(collection))
    end
  end
end
