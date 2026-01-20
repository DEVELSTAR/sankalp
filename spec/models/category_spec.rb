require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it { should have_many(:sankalps).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    subject { build(:category) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of(:color) }
  end

  describe 'scopes' do
    describe '.ordered' do
      it 'orders categories by name' do
        cat_b = create(:category, name: 'Bravo')
        cat_a = create(:category, name: 'Alpha')
        cat_c = create(:category, name: 'Charlie')

        expect(Category.ordered).to eq([ cat_a, cat_b, cat_c ])
      end
    end
  end

  describe '#sankalps_count' do
    it 'returns the number of sankalps' do
      category = create(:category)
      user = create(:user)
      create_list(:sankalp, 3, category: category, user: user)

      expect(category.sankalps_count).to eq(3)
    end
  end
end
