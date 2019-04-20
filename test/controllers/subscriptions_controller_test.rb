require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should subscribe topic" do
    user = create(:user)
    topic = create(:topic)
    sign_in_as user
    assert_difference "Subscription.count" do
      patch topic_subscription_url(topic), params: { status: 'subscribed' }, xhr: true
    end
    assert user.subscriptions.subscribed.where(topic: topic).exists?
    assert topic.subscriptions.subscribed.where(user: user).exists?
  end

  test "should ignore topic" do
    user = create(:user)
    topic = create(:topic)
    sign_in_as user
    assert_difference "Subscription.count" do
      patch topic_subscription_url(topic), params: { status: 'ignored' }, xhr: true
    end
    assert user.subscriptions.ignored.where(topic: topic).exists?
    assert topic.subscriptions.ignored.where(user: user).exists?
  end

  test "should change subscribe to ignore" do
    user = create(:user)
    topic = create(:topic)
    topic.subscriptions.create(user: user, status: 'subscribed')
    sign_in_as user
    assert_no_difference "Subscription.count" do
      patch topic_subscription_url(topic), params: { status: 'ignored' }, xhr: true
    end
    assert user.subscriptions.ignored.where(topic: topic).exists?
    assert topic.subscriptions.ignored.where(user: user).exists?
  end

  test "should destroy subscription" do
    user = create(:user)
    topic = create(:topic)
    topic.subscriptions.create(user: user, status: 'subscribed')
    sign_in_as user
    assert_difference "Subscription.count", -1 do
      delete topic_subscription_url(topic), xhr: true
    end
    assert_not user.subscriptions.where(topic: topic).exists?
    assert_not topic.subscriptions.where(user: user).exists?
  end
end
