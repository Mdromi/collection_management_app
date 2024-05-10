class Item < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :comments
  has_many :likes

  belongs_to :collection
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :item_tags, dependent: :destroy
  has_many :tags, through: :item_tags

  validates :name, presence: true

  # Define a new attribute for storing tags
  serialize :tags, Array
end
