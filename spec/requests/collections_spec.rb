require "rails_helper"

RSpec.describe CollectionsController, type: :request do
  # render_views
  describe "GET #index" do
    it "returns a successful response" do
      get collections_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:collection) { create(:collection) }

    it "returns a successful response" do
      get collection_path(collection)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "returns a successful response" do
      get new_collection_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it "creates a new collection" do
        expect {
          post collections_path, params: { collection: attributes_for(:collection, user_id: user.id) }
        }.to change(Collection, :count).by(1)
      end

      it "redirects to the created collection" do
        post collections_path, params: { collection: attributes_for(:collection, user_id: user.id) }
        expect(response).to redirect_to(collection_path(Collection.last))
      end
    end

    context "with invalid parameters" do
      before do
        sign_in create(:user)
      end

      it "does not create a new collection" do
        expect {
          post collections_path, params: { collection: attributes_for(:collection, name: nil) }
        }.to_not change(Collection, :count)
      end

      it "renders the new template" do
        post collections_path, params: { collection: attributes_for(:collection, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let(:user) { create(:user) }
    let(:collection) { create(:collection, user: user) }

    before do
      sign_in user
    end

    it "returns a successful response" do
      get edit_collection_path(collection)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }
    let(:collection) { create(:collection, user: user) }

    before do
      sign_in user
    end

    context "with valid parameters" do
      it "updates the collection" do
        patch collection_path(collection), params: { collection: { name: "Updated Name" } }
        collection.reload
        expect(collection.name).to eq("Updated Name")
      end

      it "redirects to the updated collection" do
        patch collection_path(collection), params: { collection: { name: "Updated Name" } }
        expect(response).to redirect_to(collection_path(collection))
      end
    end

    context "with invalid parameters" do
      it "does not update the collection" do
        patch collection_path(collection), params: { collection: { name: nil } }
        collection.reload
        expect(collection.name).not_to be_nil
      end

      it "renders the edit template" do
        patch collection_path(collection), params: { collection: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:collection) { create(:collection) }
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "destroys the collection" do
      expect {
        delete collection_path(collection)
      }.to change(Collection, :count).by(0)
    end

    it "redirects to the collections list" do
      delete collection_path(collection)
      expect(response).to redirect_to(collections_path)
    end
  end
end
