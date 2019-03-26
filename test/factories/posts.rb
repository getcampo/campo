FactoryBot.define do
  factory :post do
    topic
    user
    body { "body" }
  end
end
