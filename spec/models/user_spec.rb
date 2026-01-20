require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sankalps).dependent(:destroy) }
    it { should have_many(:daily_activities).through(:sankalps) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(user: 0, admin: 1) }
  end

  describe '#full_name' do
    it 'returns the full name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '#admin?' do
    it 'returns true for admin users' do
      admin = build(:user, :admin)
      expect(admin.admin?).to be true
    end

    it 'returns false for regular users' do
      user = build(:user)
      expect(user.admin?).to be false
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'orders users by created_at desc' do
        old_user = create(:user, created_at: 2.days.ago)
        new_user = create(:user, created_at: 1.day.ago)

        expect(User.ordered).to eq([ new_user, old_user ])
      end
    end
  end
end
