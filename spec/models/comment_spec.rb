require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it "belongs_to user" do
      assc = described_class.reflect_on_association(:user)
      expect(assc.macro).to eq :belongs_to
    end
    it "belongs_to item" do
      assc = described_class.reflect_on_association(:item)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe "validations" do
    it "requires content" do
      comment = described_class.new
      expect(comment).not_to be_valid
      expect(comment.errors[:content]).to include("can't be blank")
    end
  end

  describe "creating a comment on an item" do
    let(:user) { create(:user) }
    let(:collection) { create(:collection, user: user) }
    let(:item) { create(:item, collection: collection) }

    it "creates a comment on an item" do
      comment = Comment.create(user: user, item: item, content: "Test comment")
      expect(comment).to be_valid
      expect(item.comments.count).to eq(1)
      expect(item.comments).to include(comment)
    end
  end
end
