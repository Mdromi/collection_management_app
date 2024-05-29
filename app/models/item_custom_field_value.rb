class ItemCustomFieldValue < ApplicationRecord
  belongs_to :item
  belongs_to :custom_field

  validates :value, presence: true
end
