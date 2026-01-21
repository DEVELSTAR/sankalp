class DailyActivity < ApplicationRecord
  include Orderable

  # Associations
  belongs_to :sankalp, class_name: "SankalpRecord", foreign_key: :sankalp_id
  has_one :user, through: :sankalp

  # Validations
  validates :activity_date, presence: true
  validates :sankalp_id, uniqueness: { scope: :activity_date, message: "already has an activity for this date" }
  validate :activity_date_within_sankalp_range

  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :for_date, ->(date) { where(activity_date: date) }
  scope :for_date_range, ->(start_date, end_date) { where(activity_date: start_date..end_date) }
  scope :today, -> { where(activity_date: Date.current) }
  scope :this_week, -> { where(activity_date: Date.current.beginning_of_week..Date.current.end_of_week) }
  scope :this_month, -> { where(activity_date: Date.current.beginning_of_month..Date.current.end_of_month) }

  # Callbacks
  before_validation :set_default_date, on: :create

  # Instance methods
  def mark_complete!
    update!(completed: true)
  end

  def mark_incomplete!
    update!(completed: false)
  end

  def toggle_completion!
    update!(completed: !completed)
  end

  private

  def set_default_date
    self.activity_date ||= Date.current
  end

  def activity_date_within_sankalp_range
    return unless activity_date.present? && sankalp.present?

    if activity_date < sankalp.start_date
      errors.add(:activity_date, "cannot be before sankalp start date")
    end

    if sankalp.end_date.present? && activity_date > sankalp.end_date
      errors.add(:activity_date, "cannot be after sankalp end date")
    end
  end
end
