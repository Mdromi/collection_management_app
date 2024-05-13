require "rails_helper"

RSpec.describe Item, type: :model do
  describe "creating a collection with items" do
    let(:user) { create(:user) }

    it "creates a collection with items and tags" do
      collection = user.collections.create(name: "My Collection", description: "Description")
      
      item1_tags = ["tag1", "tag2", "tag3"]
      item2_tags = ["tag4", "tag5"]
    
      item1 = collection.items.create(name: "Item 1", description: "Description 1", tags: item1_tags)
      item2 = collection.items.create(name: "Item 2", description: "Description 2", tags: item2_tags)
    
      expect(collection).to be_valid
      expect(item1).to be_valid
      expect(item2).to be_valid
    
      expect(collection.items.count).to eq(2)
      expect(collection.items).to include(item1)
      expect(collection.items).to include(item2)
    
      expect(item1.tags).to eq(item1_tags)
      expect(item2.tags).to eq(item2_tags)
    end
    
  end

  describe "creating a collection with items" do
    let(:user) { create(:user) }
    let(:collection) { create(:collection, user: user) }

    it "creates a collection with items, tags, and custom fields" do
      # collection = user.collections.create(name: "My Collection", description: "Description")

      # Define custom fields for the collection
      custom_field1 = collection.custom_fields.create(label: "Director", data_type: "string")
      custom_field2 = collection.custom_fields.create(label: "IMDb Rating", data_type: "float")

      # Create items with custom field values
      item1_custom_values = { custom_field1.label => "Director 1", custom_field2.label => 8.2 }
      item2_custom_values = { custom_field1.label => "Director 2", custom_field2.label => 7.5 }

      item1 = collection.items.create(name: "Item 1", description: "Description 1", custom_field_values: item1_custom_values)
      item2 = collection.items.create(name: "Item 2", description: "Description 2", custom_field_values: item2_custom_values)

      # Assertions
      expect(collection).to be_valid
      expect(item1).to be_valid
      expect(item2).to be_valid

      expect(collection.items.count).to eq(2)
      expect(collection.items).to include(item1)
      expect(collection.items).to include(item2)

      # Test custom field values for item1
      expect(item1.custom_field_values[custom_field1.label]).to eq("Director 1")
      expect(item1.custom_field_values[custom_field2.label]).to eq(8.2)

      # Test custom field values for item2
      expect(item2.custom_field_values[custom_field1.label]).to eq("Director 2")
      expect(item2.custom_field_values[custom_field2.label]).to eq(7.5)
    end
  end
end
