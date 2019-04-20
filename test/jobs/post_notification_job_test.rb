require 'test_helper'

class PostNotificationJobTest < ActiveJob::TestCase
  test "should create post notifications" do
    post = create(:post)
    assert_difference "post.topic.user.notifications.post.count" do
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

  test "should not create post notification for topic author" do
    topic = create(:topic)
    post = create(:post, topic: topic, user: topic.user)
    assert_no_difference "post.topic.user.notifications.post.count" do
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

  test "should not create duplicate notification for topic author" do
    topic = create(:topic)
    post = create(:post, topic: topic, body: "@#{topic.user.username}")
    assert_difference "topic.user.notifications.count" do
      PostNotificationJob.perform_now(post)
    end
  end
end
