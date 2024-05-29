class Collection < ApplicationRecord
  belongs_to :user
  has_many :custom_fields, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true
  # accepts_nested_attributes_for :custom_fields, allow_destroy: true
end
