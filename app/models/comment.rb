class Comment < ApplicationRecord
  include Trashable, Editable

  belongs_to :topic, touch: :activated_at, counter_cache: true
  belongs_to :user
  belongs_to :reply_to_comment, class_name: 'Comment', optional: true

  validates :content, presence: true
end
