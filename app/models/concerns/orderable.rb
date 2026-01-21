# frozen_string_literal: true

module Orderable
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order(created_at: :desc) }
    scope :recent, -> { order(updated_at: :desc) }
  end
end
