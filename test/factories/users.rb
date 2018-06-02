FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:username) { |n| "username#{n}" }
    sequence(:email) { |n| "username#{n}@example.com" }
    password { SecureRandom.base58 }

    trait :admin do
      email User::ADMIN_EMAILS.first
    end
  end
end
