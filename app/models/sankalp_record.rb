class SankalpRecord < ApplicationRecord
  self.table_name = "sankalps"

  # Override model name to use 'Sankalp' for routes and params
  def self.model_name
    ActiveModel::Name.new(self, nil, "Sankalp")
  end


  # Soft delete
  acts_as_paranoid

  # Associations
  belongs_to :user
  belongs_to :category
  has_many :daily_activities, foreign_key: :sankalp_id, dependent: :destroy
  has_many :rewards, foreign_key: :sankalp_id, dependent: :nullify

  after_update :check_for_completion_reward

  # Enums
  enum :status, { active: 0, completed: 1, paused: 2 }

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :start_date, presence: true
  validates :status, presence: true
  validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }

  # Scopes
  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, -> { order(updated_at: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :for_user, ->(user) { where(user: user) }

  # Instance methods
  def completion_percentage
    return 0 if total_days.zero?
    ((completed_days.to_f / total_days) * 100).round(1)
  end

  def total_days
    return 0 unless start_date.present?
    end_date_for_calculation = end_date || Date.current
    [ (end_date_for_calculation - start_date).to_i + 1, 0 ].max
  end

  def completed_days
    daily_activities.where(completed: true).count
  end

  def current_streak
    calculate_streak
  end

  def longest_streak
    calculate_longest_streak
  end

  def today_activity
    daily_activities.find_by(activity_date: Date.current)
  end

  def completed_today?
    today_activity&.completed? || false
  end

  def days_remaining
    return 0 unless end_date.present?
    [ (end_date - Date.current).to_i, 0 ].max
  end

  def overdue?
    end_date.present? && end_date < Date.current && !completed?
  end

  private

  def check_for_completion_reward
    if saved_change_to_status? && completed?
      unless user.rewards.where(sankalp_id: id, title: "Sankalp Champion").exists?
        Reward.create(
          user: user,
          sankalp: self,
          title: "Sankalp Champion",
          message: "Congratulations! You have completed your Sankalp - #{title}. Keep up the great work!",
          icon: "trophy"
        )
      end
    end
  end

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def calculate_streak
    streak = 0
    date = Date.current

    loop do
      activity = daily_activities.find_by(activity_date: date, completed: true)
      break unless activity
      streak += 1
      date -= 1.day
    end

    streak
  end

  def calculate_longest_streak
    completed_dates = daily_activities
      .where(completed: true)
      .order(:activity_date)
      .pluck(:activity_date)

    return 0 if completed_dates.empty?

    longest = 1
    current = 1

    (1...completed_dates.length).each do |i|
      if completed_dates[i] - completed_dates[i - 1] == 1
        current += 1
        longest = [ longest, current ].max
      else
        current = 1
      end
    end

    longest
  end
end
