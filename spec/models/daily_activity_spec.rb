require 'rails_helper'

RSpec.describe DailyActivity, type: :model do
  describe 'associations' do
    it { should belong_to(:sankalp) }
    it { should have_one(:user).through(:sankalp) }
  end

  describe 'validations' do
    subject { build(:daily_activity) }

    it { should validate_presence_of(:activity_date).on(:update) }

    it 'validates uniqueness of sankalp_id scoped to activity_date' do
      sankalp = create(:sankalp)
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current)

      duplicate = build(:daily_activity, sankalp: sankalp, activity_date: Date.current)
      expect(duplicate).not_to be_valid
    end

    it 'allows same date for different sankalps' do
      create(:daily_activity, activity_date: Date.current)
      second = build(:daily_activity, activity_date: Date.current)

      expect(second).to be_valid
    end
  end

  describe 'date validation' do
    let(:sankalp) { create(:sankalp, start_date: Date.current, end_date: Date.current + 30.days) }

    it 'is invalid when activity_date is before sankalp start_date' do
      activity = build(:daily_activity, sankalp: sankalp, activity_date: Date.current - 1.day)
      expect(activity).not_to be_valid
      expect(activity.errors[:activity_date]).to include('cannot be before sankalp start date')
    end

    it 'is invalid when activity_date is after sankalp end_date' do
      activity = build(:daily_activity, sankalp: sankalp, activity_date: Date.current + 60.days)
      expect(activity).not_to be_valid
      expect(activity.errors[:activity_date]).to include('cannot be after sankalp end date')
    end

    it 'is valid when activity_date is within range' do
      activity = build(:daily_activity, sankalp: sankalp, activity_date: Date.current + 15.days)
      expect(activity).to be_valid
    end
  end

  describe 'scopes' do
    describe '.completed' do
      it 'returns only completed activities' do
        completed = create(:daily_activity, :completed)
        pending = create(:daily_activity, :pending)

        expect(DailyActivity.completed).to include(completed)
        expect(DailyActivity.completed).not_to include(pending)
      end
    end

    describe '.pending' do
      it 'returns only pending activities' do
        completed = create(:daily_activity, :completed)
        pending = create(:daily_activity, :pending)

        expect(DailyActivity.pending).to include(pending)
        expect(DailyActivity.pending).not_to include(completed)
      end
    end

    describe '.today' do
      it 'returns activities for today' do
        sankalp = create(:sankalp, start_date: 2.days.ago)
        today_activity = create(:daily_activity, sankalp: sankalp, activity_date: Date.current)
        yesterday_activity = create(:daily_activity, sankalp: sankalp, activity_date: Date.current - 1.day)

        expect(DailyActivity.today).to include(today_activity)
        expect(DailyActivity.today).not_to include(yesterday_activity)
      end
    end
  end

  describe '#toggle_completion!' do
    it 'toggles completed from false to true' do
      activity = create(:daily_activity, completed: false)
      activity.toggle_completion!
      expect(activity.completed).to be true
    end

    it 'toggles completed from true to false' do
      activity = create(:daily_activity, completed: true)
      activity.toggle_completion!
      expect(activity.completed).to be false
    end
  end

  describe '#mark_complete!' do
    it 'marks the activity as completed' do
      activity = create(:daily_activity, completed: false)
      activity.mark_complete!
      expect(activity.completed).to be true
    end
  end

  describe '#mark_incomplete!' do
    it 'marks the activity as incomplete' do
      activity = create(:daily_activity, completed: true)
      activity.mark_incomplete!
      expect(activity.completed).to be false
    end
  end
end
