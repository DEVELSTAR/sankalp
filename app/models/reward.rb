class Reward < ApplicationRecord
  include Orderable

  belongs_to :user
  belongs_to :sankalp, class_name: "SankalpRecord", optional: true

  validates :title, presence: true
  validates :message, presence: true

  scope :unread, -> { where(read_at: nil) }

  def mark_as_read!
    update(read_at: Time.current)
  end

  def read?
    read_at.present?
  end
end
