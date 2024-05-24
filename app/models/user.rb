class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :collections, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }

  enum role: { regular: 0, admin: 1 }

  after_initialize :set_default_role, if: :new_record?

  def update_without_password(params, *options)
    params.delete(:password)
    params.delete(:password_confirmation)
    clean_up_passwords
    update(params, *options)
  end

  private

  def set_default_role
    self.role ||= :regular
  end
end
