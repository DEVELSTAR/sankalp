class User < ApplicationRecord
  include Orderable

  self.table_name = "sankalp_users"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :sankalps, class_name: "SankalpRecord", dependent: :destroy
  has_many :sankalp_assignments, dependent: :destroy
  has_many :assigned_sankalps, through: :sankalp_assignments, source: :sankalp
  has_many :daily_activities, through: :sankalps
  has_many :categories, dependent: :destroy
  has_many :rewards, dependent: :destroy

  # Enums
  enum :role, { user: 0, admin: 1 }

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == "admin"
  end
end
