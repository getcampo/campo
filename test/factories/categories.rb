FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category#{n}" }
    sequence(:slug) { |n| "category#{n}" }
  end
end
