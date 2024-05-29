class CustomField < ApplicationRecord
  belongs_to :collection

  validates :label, presence: true
  validates :data_type, presence: true
  has_many :item_custom_field_values, dependent: :destroy
end
