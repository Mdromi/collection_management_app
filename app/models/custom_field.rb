class CustomField < ApplicationRecord
  belongs_to :collection

  validates :label, presence: true
  validates :data_type, presence: true
end
