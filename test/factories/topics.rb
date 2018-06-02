FactoryBot.define do
  factory :topic do
    user
    forum
    title 'Title'
    content 'Content'
  end
end
