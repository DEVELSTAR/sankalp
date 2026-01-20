require 'rails_helper'

RSpec.describe "DailyActivities", type: :request do
  let(:user) { create(:user) }
  let(:sankalp) { create(:sankalp, user: user) }
  let(:daily_activity) { create(:daily_activity, sankalp: sankalp) }

  before { sign_in user }

  describe "GET /sankalps/:sankalp_id/daily_activities/new" do
    it "returns http success" do
      get new_sankalp_daily_activity_path(sankalp)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sankalps/:sankalp_id/daily_activities" do
    let(:valid_attributes) do
      {
        activity_date: Date.current,
        notes: "Test notes",
        completed: true
      }
    end

    it "creates a new daily activity" do
      expect {
        post sankalp_daily_activities_path(sankalp), params: { daily_activity: valid_attributes }
      }.to change(DailyActivity, :count).by(1)
    end

    it "redirects to the sankalp" do
      post sankalp_daily_activities_path(sankalp), params: { daily_activity: valid_attributes }
      expect(response).to redirect_to(sankalp)
    end
  end

  describe "PATCH /sankalps/:sankalp_id/daily_activities/:id" do
    it "updates the daily activity" do
      patch sankalp_daily_activity_path(sankalp, daily_activity),
            params: { daily_activity: { notes: "Updated notes" } }
      daily_activity.reload
      expect(daily_activity.notes).to eq("Updated notes")
    end
  end

  describe "POST /sankalps/:sankalp_id/daily_activities/:id/toggle" do
    it "toggles the completion status" do
      daily_activity.update!(completed: false)
      post toggle_sankalp_daily_activity_path(sankalp, daily_activity)
      daily_activity.reload
      expect(daily_activity.completed).to be true
    end
  end

  describe "DELETE /sankalps/:sankalp_id/daily_activities/:id" do
    it "deletes the daily activity" do
      daily_activity
      expect {
        delete sankalp_daily_activity_path(sankalp, daily_activity)
      }.to change(DailyActivity, :count).by(-1)
    end
  end
end
