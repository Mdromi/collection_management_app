class Item < ApplicationRecord
  belongs_to :collection, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :name, presence: true
  has_many :item_custom_field_values, dependent: :destroy

  accepts_nested_attributes_for :item_custom_field_values
end
