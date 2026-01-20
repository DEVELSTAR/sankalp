FactoryBot.define do
  factory :daily_activity do
    activity_date { Date.current }
    notes { Faker::Lorem.sentence }
    completed { false }
    association :sankalp

    trait :completed do
      completed { true }
    end

    trait :pending do
      completed { false }
    end
  end
end
