FactoryBot.define do
  factory :forum do
    sequence(:name) { |n| "Forum#{n}" }
    sequence(:slug) { |n| "forum#{n}" }
  end
end
