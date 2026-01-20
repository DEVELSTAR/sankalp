class Category < ApplicationRecord
  self.table_name = "sankalp_categories"
  belongs_to :user, optional: true

  # Associations
  has_many :sankalps, class_name: "SankalpRecord", dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :color, presence: true

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :global, -> { where(user_id: nil) }
  scope :owned_by, ->(user) { where(user_id: user.id) }
  scope :accessible_by_user, ->(user) { where(user_id: [ nil, user.id ]) }

  def global?
    user_id.nil?
  end

  # Class methods
  def self.with_sankalp_count
    left_joins(:sankalps)
      .select("#{table_name}.*, COUNT(sankalps.id) as sankalps_count")
      .group("#{table_name}.id")
  end

  # Instance methods
  def sankalps_count
    sankalps.count
  end
end
