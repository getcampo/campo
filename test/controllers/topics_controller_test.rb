require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get topic page" do
    get topic_url(topics(:topic))
    assert_response :success
  end

  test "should get new page" do
    sign_in_as(users(:user))
    get new_topic_url
    assert_response :success
  end

  test "should create topic" do
    sign_in_as(users(:user))
    assert_difference "Topic.count" do
      post topics_url, params: { topic: { title: 'Title', forum_id: forums(:forum).id, content: 'Content'}}
    end
    topic = Topic.last
    assert_redirected_to topic_path(topic)
    assert_equal users(:user), topic.user
  end

  test "should get edit page" do
    sign_in_as(users(:user))
    get edit_topic_url(topics(:topic))
    assert_response :success
  end

  test "should update topic" do
    sign_in_as(users(:user))
    patch topic_url(topics(:topic)), params: { topic: { title: 'Change' } }
    assert_redirected_to topic_url(topics(:topic))
    assert_equal 'Change', topics(:topic).reload.title
  end

  test "should trash topic" do
    sign_in_as(users(:user))
    put trash_topic_url(topics(:topic))
    assert topics(:topic).reload.trashed?
  end
end
