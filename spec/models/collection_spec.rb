require "rails_helper"

RSpec.describe Collection, type: :model do
  describe "associations" do
    it "belongs to a user" do
      expect(Collection.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "has many items" do
      expect(Collection.reflect_on_association(:items).macro).to eq(:has_many)
    end
  end

  describe "validations" do
    it "validates the presence of name" do
      collection = Collection.new(description: "Test description", user: create(:user))
      expect(collection).not_to be_valid
      expect(collection.errors[:name]).to include("can't be blank")
    end

    it "validates the presence of user" do
      collection = Collection.new(name: "Test Collection", description: "Test description")
      expect(collection).not_to be_valid
      expect(collection.errors[:user]).to include("must exist")
    end
  end

  describe "creating collections for a user" do
    let(:user) { create(:user) }

    it "creates a collection for a user" do
      collection = user.collections.create(name: "My Collection", description: "Description")
      expect(collection).to be_valid
      expect(user.collections.count).to eq(1)
      expect(user.collections.first).to eq(collection)
    end

    it "allows a user to have multiple collections" do
      user.collections.create(name: "Collection 1", description: "Description")
      user.collections.create(name: "Collection 2", description: "Description")
      expect(user.collections.count).to eq(2)
    end
  end
end
