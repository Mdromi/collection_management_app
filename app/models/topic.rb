class Topic < ApplicationRecord
  belongs_to :user

  validates :name, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at] # Add or remove attributes as needed
  end
end
