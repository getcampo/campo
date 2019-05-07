FactoryBot.define do
  factory :topic do
    user
    forum
    category
    title { 'Title' }
  end
end
