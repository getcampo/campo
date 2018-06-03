require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "should create mention notifications" do
    user = create(:user, username: 'foobar')
    assert_difference "user.notifications.count" do
      create(:topic, content: '@foobar').create_notifications
    end
    topic = Topic.last
    assert_equal [user], topic.mention_users
    notification = user.notifications.last
    assert_equal 'mention', notification.name
    assert_equal topic, notification.record
  end
end
