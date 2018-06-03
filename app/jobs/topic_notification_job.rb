class TopicNotificationJob < ApplicationJob
  queue_as :default

  def perform(topic)
    topic.create_notifications
  end
end
