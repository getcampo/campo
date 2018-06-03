require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "should create comment notifications" do
    topic = create(:topic)
    assert_difference "topic.user.notifications.count" do
      create(:comment, topic: topic)
    end
    notification = topic.user.notifications.last
    assert_equal 'comment', notification.name
    assert_equal Comment.last, notification.source
  end

  test "should create reply notifications" do
    comment = create(:comment)
    assert_difference "comment.user.notifications.count" do
      create(:comment, reply_to_comment: comment)
    end
    notification = comment.user.notifications.last
    assert_equal 'reply', notification.name
    assert_equal Comment.last, notification.source
  end

  test "should not create duplicate reply notifications for topic user" do
    topic = create(:topic)
    comment = create(:comment, topic: topic, user: topic.user)
    assert_difference "comment.user.notifications.count" do
      create(:comment, topic: topic, reply_to_comment: comment)
    end
    notification = topic.user.notifications.last
    assert_equal 'comment', notification.name
    assert_equal Comment.last, notification.source
  end

  test "should create notification for mention user" do
    user = create(:user, username: 'foobar')
    assert_difference "user.notifications.count" do
      create(:comment, content: '@foobar')
    end
    comment = Comment.last
    assert_equal [user], comment.mention_users
    notification = user.notifications.last
    assert_equal 'mention', notification.name
    assert_equal comment, notification.source
  end
end
