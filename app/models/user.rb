class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :sankalps, class_name: "SankalpRecord", dependent: :destroy
  has_many :daily_activities, through: :sankalps

  # Enums
  enum :role, { user: 0, admin: 1 }

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true

  # Scopes
  scope :ordered, -> { order(created_at: :desc) }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == "admin"
  end
end
