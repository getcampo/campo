FactoryBot.define do
  factory :topic do
    user
    forum
    title { 'Title' }
  end
end
