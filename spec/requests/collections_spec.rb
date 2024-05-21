require "rails_helper"

RSpec.describe "Collections", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/collections"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /collections" do
    it "creates a new collection" do
      # Create a user
      user = FactoryBot.create(:user)

      # Log in the user
      sign_in user

      # Send a POST request to create a collection
      post "/collections", params: { collection: { name: "Test Collection", description: "Test Description", topic: "Books" } }

      # Check if the response status is a redirect
      expect(response).to have_http_status(:redirect)

      # Check if the collection was actually created in the database
      expect(Collection.count).to eq(1)
      expect(Collection.first.name).to eq("Test Collection")
    end
  end

  describe "PATCH /collections/:id" do
    it "updates an existing collection" do
      # Create a user and a collection
      user = FactoryBot.create(:user)
      collection = FactoryBot.create(:collection, user: user)

      # Log in the user
      sign_in user

      # Send a PATCH request to update the collection
      patch "/collections/#{collection.id}", params: { collection: { name: "Updated Collection Name" } }

      # Check if the response status is a redirect
      expect(response).to have_http_status(:redirect)

      # Reload the collection from the database
      collection.reload

      # Check if the collection was actually updated
      expect(collection.name).to eq("Updated Collection Name")
    end
  end

  describe "DELETE /collections/:id" do
    it "deletes an existing collection" do
      # Create a user and a collection
      user = FactoryBot.create(:user)
      collection = FactoryBot.create(:collection, user: user)

      # Log in the user
      sign_in user

      # Send a DELETE request to delete the collection
      delete "/collections/#{collection.id}"

      # Check if the response status is a redirect
      expect(response).to have_http_status(:redirect)

      # Check if the collection was actually deleted from the database
      expect(Collection.exists?(collection.id)).to be_falsy
    end
  end
end
