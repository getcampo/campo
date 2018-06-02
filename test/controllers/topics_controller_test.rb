require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get topic page" do
    get topic_url(create(:topic))
    assert_response :success
  end

  test "should get new page" do
    sign_in_as(create(:user))
    get new_topic_url
    assert_response :success
  end

  test "should create topic" do
    user = create(:user)
    sign_in_as(user)
    assert_difference "Topic.count" do
      post topics_url, params: { topic: { title: 'Title', forum_id: create(:forum).id, content: 'Content'}}
    end
    topic = Topic.last
    assert_redirected_to topic_path(topic)
    assert_equal user, topic.user
  end

  test "should get edit page" do
    topic = create(:topic)
    sign_in_as(topic.user)
    get edit_topic_url(topic)
    assert_response :success
  end

  test "should update topic" do
    topic = create(:topic)
    sign_in_as(topic.user)
    patch topic_url(topic), params: { topic: { title: 'Change' } }
    assert_redirected_to topic_url(topic)
    assert_equal 'Change', topic.reload.title
    assert_equal topic.user, topic.edited_user
  end

  test "should trash topic by admin" do
    topic = create(:topic)
    sign_in_as(create(:user, :admin))
    put trash_topic_url(topic)
    assert topic.reload.trashed?
  end

  test "should not trash topic by user" do
    topic = create(:topic)
    sign_in_as(topic.user)
    put trash_topic_url(topic)
    assert_not topic.reload.trashed?
  end
end
