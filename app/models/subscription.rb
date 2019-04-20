class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  enum status: {
    subscribed: 0,
    ignored: 1
  }
end
