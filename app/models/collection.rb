class Collection < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :custom_fields, dependent: :destroy

  validates :name, presence: true
end
