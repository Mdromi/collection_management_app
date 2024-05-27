class Collection < ApplicationRecord
  belongs_to :user
  # has_many :items, dependent: :destroy, counter_cache: true
  has_many :items, dependent: :destroy

  validates :name, presence: true
end
