class Comment < ApplicationRecord
  include Trashable, Editable

  belongs_to :topic, touch: true, counter_cache: true
  belongs_to :user
  belongs_to :reply_to_comment, class_name: 'Comment', optional: true

  validates :content, presence: true

  after_commit :create_comment_notifications, :create_reply_notifications, on: [:create]

  private

  def create_comment_notifications
    if user != topic.user
      topic.user.notifications.create(name: 'comment', source: self)
    end
  end

  def create_reply_notifications
    if reply_to_comment && user != reply_to_comment.user && reply_to_comment.user != topic.user
      reply_to_comment.user.notifications.create(name: 'reply', source: self)
    end
  end
end
