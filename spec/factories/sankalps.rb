FactoryBot.define do
  factory :sankalp, class: "SankalpRecord" do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    status { :active }
    start_date { Date.current }
    end_date { 30.days.from_now }
    association :user
    association :category

    trait :active do
      status { :active }
    end

    trait :completed do
      status { :completed }
    end

    trait :paused do
      status { :paused }
    end

    trait :ongoing do
      end_date { nil }
    end
  end
end
