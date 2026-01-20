class RewardsController < ApplicationController
  def show
    @reward = current_user.rewards.find(params[:id])

    # Mark as read if not already
    @reward.mark_as_read! unless @reward.read?
  end
end
