class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :collections, dependent: :destroy
  has_many :items, through: :collections
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :tags, dependent: :destroy

  STATUSES = %w[active blocked].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }

  enum role: { regular: 0, admin: 1 }

  scope :active, -> { where(status: "active") }
  scope :blocked, -> { where(status: "blocked") }

  after_initialize :set_default_role, if: :new_record?

  def update_without_password(params, *options)
    params.delete(:password)
    params.delete(:password_confirmation)
    clean_up_passwords
    update(params, *options)
  end

  def active?
    status == "active"
  end

  def blocked?
    status == "blocked"
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    blocked? ? :blocked : super
  end

  private

  def set_default_role
    self.role ||= :regular
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id username email role status created_at updated_at]
  end

  def self.from_google(u)
    create_with(uid: u[:uid], provider: "google",
                password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end
end
