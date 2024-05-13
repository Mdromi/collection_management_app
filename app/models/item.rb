class Item < ApplicationRecord
  belongs_to :collection
  # belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  validates :name, presence: true

  # serialize :custom_field_values, JSON
end
