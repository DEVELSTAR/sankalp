require 'rails_helper'

RSpec.describe SankalpRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:daily_activities).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(active: 0, completed: 1, paused: 2) }
  end

  describe 'date validation' do
    it 'is invalid when end_date is before start_date' do
      sankalp = build(:sankalp, start_date: Date.current, end_date: Date.current - 1.day)
      expect(sankalp).not_to be_valid
      expect(sankalp.errors[:end_date]).to include('must be after start date')
    end

    it 'is valid when end_date is after start_date' do
      sankalp = build(:sankalp, start_date: Date.current, end_date: Date.current + 1.day)
      expect(sankalp).to be_valid
    end
  end

  describe '#completion_percentage' do
    it 'returns 0 when there are no days' do
      sankalp = build(:sankalp, start_date: Date.current, end_date: Date.current - 1.day)
      expect(sankalp.completion_percentage).to eq(0)
    end

    it 'calculates the correct percentage' do
      sankalp = create(:sankalp, start_date: 9.days.ago, end_date: Date.current)
      # Total 10 days including today

      # Create 5 completed activities
      (0..4).each do |i|
        create(:daily_activity, sankalp: sankalp, completed: true, activity_date: i.days.ago)
      end

      expect(sankalp.completion_percentage).to eq(50.0)
    end
  end

  describe '#current_streak' do
    let(:sankalp) { create(:sankalp, start_date: 10.days.ago) }

    it 'returns 0 when there are no completed activities' do
      expect(sankalp.current_streak).to eq(0)
    end

    it 'calculates streak correctly' do
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current, completed: true)
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current - 1.day, completed: true)
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current - 2.days, completed: true)

      expect(sankalp.current_streak).to eq(3)
    end

    it 'breaks streak when a day is missed' do
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current, completed: true)
      # Missing yesterday
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current - 2.days, completed: true)

      expect(sankalp.current_streak).to eq(1)
    end
  end

  describe '#completed_today?' do
    let(:sankalp) { create(:sankalp) }

    it 'returns false when no activity today' do
      expect(sankalp.completed_today?).to be false
    end

    it 'returns true when activity is completed today' do
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current, completed: true)
      expect(sankalp.completed_today?).to be true
    end

    it 'returns false when activity exists but not completed' do
      create(:daily_activity, sankalp: sankalp, activity_date: Date.current, completed: false)
      expect(sankalp.completed_today?).to be false
    end
  end

  describe 'soft delete' do
    it 'soft deletes the sankalp' do
      sankalp = create(:sankalp)
      sankalp.destroy

      expect(SankalpRecord.count).to eq(0)
      expect(SankalpRecord.with_deleted.count).to eq(1)
    end
  end
end
