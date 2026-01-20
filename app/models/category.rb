class Category < ApplicationRecord
  self.table_name = "sankalp_categories"
  # Associations
  has_many :sankalps, class_name: "SankalpRecord", dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :color, presence: true

  # Scopes
  scope :ordered, -> { order(:name) }

  # Class methods
  def self.with_sankalp_count
    left_joins(:sankalps)
      .select("categories.*, COUNT(sankalps.id) as sankalps_count")
      .group("categories.id")
  end

  # Instance methods
  def sankalps_count
    sankalps.count
  end
end
