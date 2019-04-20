class PostNotificationJob < ApplicationJob
  queue_as :default

  def perform(post)
    (post.topic.subscribed_users - [post.user]).each do |user|
      user.notifications.create(type: 'post', record: post)
    end

    (post.mentioned_users - post.topic.subscribed_users - post.topic.ignored_users - [post.user]).each do |user|
      user.notifications.create(type: 'mention', record: post)
    end
  end
end
