class Tag < ApplicationRecord
  belongs_to :user

  validates :name, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at]
  end
end
