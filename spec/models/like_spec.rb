require "rails_helper"

RSpec.describe "Like", type: :model do
  describe "creating likes for items" do
    let(:user) { create(:user) }
    let(:collection) { create(:collection, user: user) }
    let(:items) { create_list(:item, 3, collection: collection) }

    it "creates likes for items" do
      items.each do |item|
        create_like(user, item)
      end

      items.each do |item|
        expect(item.likes.count).to eq(1)
        expect(item.likes.first.user).to eq(user)
      end
    end

    it "creates dislikes for items" do
      items.each do |item|
        create_like(user, item)
        create_like(user, item)
      end

      items.each do |item|
        expect(item.likes.count).to eq(0)
      end
    end

  end

  def create_like(user, item)
    existing_like = Like.find_by(user: user, item: item)
    if existing_like
      existing_like&.destroy
    else
      Like.create(user: user, item: item)
    end
  end
end
