class Comment < ApplicationRecord
  belongs_to :topic, touch: :activated_at
  belongs_to :user

  validates :content, presence: true
end
