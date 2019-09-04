class PostNotificationJob < ApplicationJob
  queue_as :default

  def perform(post)
    ignored_user_ids = post.topic.ignored_users.pluck(:id) + [post.user_id]

    if post.reply_to_post && !ignored_user_ids.include?(post.reply_to_post.user_id)
      post.reply_to_post.user.notifications.create(type: 'reply', record: post)
      ignored_user_ids.push post.reply_to_post.user_id
    end

    post.topic.subscribed_users.where.not(id: ignored_user_ids).each do |user|
      user.notifications.create(type: 'post', record: post)
      ignored_user_ids.push user.id
    end

    post.mentioned_users.where.not(id: ignored_user_ids).each do |user|
      user.notifications.create(type: 'mention', record: post)
      ignored_user_ids.push user.id
    end
  end
end
