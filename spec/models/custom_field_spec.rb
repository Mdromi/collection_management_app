require 'rails_helper'

RSpec.describe CustomField, type: :model do
  describe "associations" do
    it "belongs_to collection" do
      assc = described_class.reflect_on_association(:collection)
      expect(assc.macro).to eq :belongs_to
    end
  end

  describe "validations" do
    describe "validations" do
      it "requires label and Data Type" do
        custom_field = CustomField.new
        expect(custom_field.valid?).to be(false)
        expect(custom_field.errors[:label]).to include("can't be blank")
        expect(custom_field.errors[:data_type]).to include("can't be blank")
      end
    end
  end

  describe "creating custom fields for a collection" do
    let(:user) { create(:user) }
    let(:collection) { create(:collection, user: user) }

    it "creates a custom field for a collection" do
      custom_field = CustomField.new(label: "Director", data_type: "string", collection: collection)
      expect(custom_field.save).to be(true)
    end

    it "associates the custom field with the correct collection" do
      custom_field = CustomField.create(label: "Director", data_type: "string", collection: collection)
      expect(custom_field.collection).to eq(collection)
    end
  end
end
