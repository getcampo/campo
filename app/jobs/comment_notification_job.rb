class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment)
    comment.create_notifications
  end
end
