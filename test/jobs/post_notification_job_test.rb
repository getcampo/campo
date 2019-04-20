require 'test_helper'

class PostNotificationJobTest < ActiveJob::TestCase
  test "should create post notifications for subscriber" do
    topic = create(:topic)
    subscriber = create(:user)
    topic.subscriptions.create(user: subscriber, status: 'subscribed')
    post = create(:post, topic: topic)
    assert_difference "subscriber.notifications.post.count" do
      PostNotificationJob.perform_now(post)
    end
  end

  test "should create mention notifications" do
    user = create(:user)
    post = create(:post, body: "@#{user.username}")
    assert_difference "user.notifications.mention.count" do
      PostNotificationJob.perform_now(post)
    end
  end

  test "should not create mention notifications for ignorer" do
    topic = create(:topic)
    user = create(:user)
    topic.subscriptions.create(user: user, status: 'ignored')
    post = create(:post, topic: topic, body: "@#{user.username}")
    assert_no_difference "user.notifications.mention.count" do
      PostNotificationJob.perform_now(post)
    end
  end

  test "should not create post notifications for post author" do
    topic = create(:topic)
    topic.subscriptions.create(user: topic.user, status: 'subscribed')
    post = create(:post, topic: topic, user: topic.user)
    assert_no_difference "topic.user.notifications.post.count" do
      PostNotificationJob.perform_now(post)
    end
  end

  test "should create mention notifications for post author" do
    user = create(:user)
    post = create(:post, body: "@#{user.username}", user: user)
    assert_no_difference "user.notifications.mention.count" do
      PostNotificationJob.perform_now(post)
    end
  end

  test "should not create duplicate notification for subscriber" do
    topic = create(:topic)
    subscriber = create(:user)
    topic.subscriptions.create(user: subscriber, status: 'subscribed')
    post = create(:post, topic: topic, body: "@#{subscriber.username}")
    assert_difference "subscriber.notifications.count" do
      PostNotificationJob.perform_now(post)
    end
  end
end
