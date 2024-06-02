class Item < ApplicationRecord
  require "csv"
  belongs_to :collection, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :item_custom_field_values, dependent: :destroy  # Corrected association name

  validates :name, presence: true

  accepts_nested_attributes_for :item_custom_field_values

  def self.ransackable_attributes(auth_object = nil)
    ["collection_id", "comments_count", "created_at", "description", "id", "image", "likes_count", "name", "tags", "updated_at"]  # Removed "id_value" attribute
  end

  def self.ransackable_associations(auth_object = nil)
    ["collection", "comments", "likes"]  # Removed "item_custom_field_values" association
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      custom_field_labels = CustomField.pluck(:label)

      csv << ["Name", "Image URL", "Description", "Created At", *custom_field_labels]

      all.each do |item|
        custom_field_values = custom_field_values_for_item(item)
        csv << [
          item.name,
          item.image,
          item.description,
          item.created_at,
          *custom_field_values,
        ]
      end
    end
  end

  def self.custom_field_values_for_item(item)
    custom_fields = item.collection.custom_fields
    custom_fields.map { |field| item.custom_field_value_for_field(field) }
  end

  def custom_field_value_for_field(field)
    item_custom_field_values.find_by(custom_field_id: field.id)&.value
  end
end
