class Item < ApplicationRecord
  require "csv"
  belongs_to :collection, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :item_custom_field_values, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :item_custom_field_values

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << ["Name", "Description", "Custom Field", "Custom Field Value", "Image URL", "Created At"]

      all.each do |item|
        csv << [
          item.name,
          item.description,
          custom_field_name_and_value(item),
          item.image,
          item.created_at,
        ]
      end
    end
  end

  def self.custom_field_name_and_value(item)
    custom_fields = item.collection.custom_fields
    custom_fields.map { |field| "#{field.label}: #{item.custom_field_value_for_field(field)}" }.join(", ")
  end

  def custom_field_value_for_field(field)
    item_custom_field_values.find_by(custom_field_id: field.id)&.value
  end
end
