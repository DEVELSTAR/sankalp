class SankalpAssignment < ApplicationRecord
  belongs_to :sankalp, class_name: "SankalpRecord"
  belongs_to :user

  validates :sankalp_id, uniqueness: { scope: :user_id }
end
