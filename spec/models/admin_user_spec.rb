require "rails_helper"

RSpec.describe User, type: :model do
  describe "as an admin user" do
    let(:admin_user) { create(:user, role: :admin) }
    let(:regular_user) { create(:user) }

    it "can perform admin actions" do
      expect(admin_user.role).to eq("admin")
    end

    it "cannot perform admin actions" do
      expect(regular_user.role).not_to eq("admin")
    end
  end

  describe "as an admin user discover application" do
    let(:admin_user) { create(:user, role: :admin) }

    it "can create multiple tags" do
      admin_user.tags.create(name: "Tag 1")
      admin_user.tags.create(name: "Tag 2")

      expect(admin_user.tags.count).to eq(2)
    end

    it "can create multiple topics" do
      admin_user.topics.create(name: "Topic 1")
      admin_user.topics.create(name: "Topic 2")

      expect(admin_user.topics.count).to eq(2)
    end

    it "can create collections for each topic" do
      topic1 = admin_user.topics.create(name: "Topic 1")
      topic2 = admin_user.topics.create(name: "Topic 2")

      collection1 = admin_user.collections.create(name: "Collection 1", description: "Description 1", topic: topic1.name)
      collection2 = admin_user.collections.create(name: "Collection 2", description: "Description 2", topic: topic2.name)

      expect(collection1.topic).to eq(topic1.name)
      expect(collection2.topic).to eq(topic2.name)
    end

    it "can create items with tags" do
      topic = admin_user.topics.create(name: "Topic")
      admin_user.tags.create(name: "Tag 1")
      admin_user.tags.create(name: "Tag 2")

      collection = admin_user.collections.create(name: "My Collection", description: "Description", topic: topic.name)

      item1 = collection.items.create(name: "Item 1", description: "Description 1")
      item1.tags << admin_user.tags.first

      item2 = collection.items.create(name: "Item 2", description: "Description 2")
      item2.tags << admin_user.tags.last

      expect(collection.items.count).to eq(2)
      expect(item1.tags.count).to eq(1)
      expect(item2.tags.count).to eq(1)
    end
  end
end
