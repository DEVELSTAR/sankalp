FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { Faker::Lorem.sentence }
    color { Faker::Color.hex_color }
    icon { "star" }
  end
end
