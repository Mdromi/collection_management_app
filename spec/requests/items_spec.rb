require "rails_helper"

RSpec.describe "Items", type: :request do
  describe "POST /collections/:collection_id/items" do
    it "creates a new item" do
      # Create a user
      user = FactoryBot.create(:user)

      # Log in the user
      sign_in user

      # Create a collection
      collection = FactoryBot.create(:collection, user: user)

      # Send a POST request to create a new item within the collection
      post "/collections/#{collection.id}/items", params: { item: { name: "Test Item", description: "Test Description" } }

      # Check if the response status is as expected
      expect(response).to have_http_status(:found) # HTTP 302

      # Follow the redirect
      follow_redirect!

      # Check if the item was actually created in the database
      expect(collection.items.count).to eq(1)
      expect(collection.items.first.name).to eq("Test Item")
    end
  end

  describe "PATCH /collections/:collection_id/items/:id" do
    it "updates an existing item" do
      # Create a user
      user = FactoryBot.create(:user)

      # Log in the user
      sign_in user

      # Create a collection
      collection = FactoryBot.create(:collection, user: user)

      # Create an item within the collection
      item = FactoryBot.create(:item, collection: collection)

      # Send a PATCH request to update the item
      patch "/collections/#{collection.id}/items/#{item.id}", params: { item: { name: "Updated Item" } }

      # Check if the response status is as expected
      expect(response).to have_http_status(:found) # HTTP 302

      # Follow the redirect
      follow_redirect!

      # Check if the item was actually updated in the database
      expect(item.reload.name).to eq("Updated Item")
    end
  end

  describe "DELETE /collections/:collection_id/items/:id" do
    it "deletes an existing item" do
      # Create a user
      user = FactoryBot.create(:user)

      # Log in the user
      sign_in user

      # Create a collection
      collection = FactoryBot.create(:collection, user: user)

      # Create an item within the collection
      item = FactoryBot.create(:item, collection: collection)

      # Send a DELETE request to delete the item
      delete "/collections/#{collection.id}/items/#{item.id}"

      # Check if the response status is as expected
      expect(response).to have_http_status(:found) # HTTP 302

      # Follow the redirect
      follow_redirect!

      # Check if the item was actually deleted from the database
      expect(collection.items.count).to eq(0)
    end
  end
end
