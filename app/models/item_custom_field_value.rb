class ItemCustomFieldValue < ApplicationRecord
  belongs_to :item
  belongs_to :custom_field

  validates :value, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "custom_field_id", "id", "id_value", "item_id", "updated_at", "value"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["custom_field", "item"]
  end
end
