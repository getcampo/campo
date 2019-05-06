FactoryBot.define do
  factory :topic do
    user
    category
    title { 'Title' }
  end
end
