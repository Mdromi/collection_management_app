require "rails_helper"

RSpec.describe CommentsController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:collection) { FactoryBot.create(:collection, user: user) }
  let(:item) { FactoryBot.create(:item, collection: collection) }

  before do
    sign_in user
  end

  describe "POST /collections/:collection_id/items/:item_id/comments" do
    it "creates a new comment" do
      expect {
        post collection_item_comments_path(collection, item), params: { comment: { content: "Test Comment" } }
      }.to change { item.comments.count }.by(1)
      expect(response).to redirect_to(collection_item_path(collection, item))
      follow_redirect!
      expect(response.body).to include("Comment was successfully created.")
    end
  end

  describe "DELETE /collections/:collection_id/items/:item_id/comments/:id" do
    let!(:comment) { FactoryBot.create(:comment, item: item, user: user) }

    it "deletes an existing comment" do
      expect {
        delete collection_item_comment_path(collection, item, comment)
      }.to change { item.comments.count }.by(-1)
      expect(response).to redirect_to(collection_item_path(collection, item))
      follow_redirect!
      expect(response.body).to include("Comment was successfully destroyed.")
    end
  end
end
