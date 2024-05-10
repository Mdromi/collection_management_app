class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :collections, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :tags, dependent: :destroy

  # Define enum for user roles
  enum role: { regular: 0, admin: 1 }

  # Validate presence and uniqueness of username
  validates :username, presence: true, uniqueness: true

  # Set default role for new users
  after_initialize :set_default_role, if: :new_record?

  private

  # Method to set default role
  def set_default_role
    self.role ||= :regular
  end
end
