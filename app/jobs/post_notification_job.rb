class PostNotificationJob < ApplicationJob
  queue_as :default

  def perform(post)
    if post.user != post.topic.user
      post.topic.user.notifications.create(type: 'post', record: post)
    end

    post.mentioned_users.each do |user|
      if post.user != user && post.topic.user != user
        user.notifications.create(type: 'mention', record: post)
      end
    end
  end
end
