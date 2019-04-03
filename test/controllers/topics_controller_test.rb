require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get topic page" do
    get topic_url(create(:topic))
    assert_response :success
  end

  test "should create topic" do
    user = create(:user)
    sign_in_as(user)
    assert_difference "Topic.count" do
      post topics_url, params: { topic: { title: 'title', forum_id: create(:forum).id, first_post_attributes: { body: 'body' } } }
    end
    topic = Topic.last
    assert_equal 'title', topic.title
    assert_equal 'body', topic.first_post.body
    assert_redirected_to topic_path(topic)
    assert_equal user, topic.user
  end

  test "should trash topic by admin" do
    topic = create(:topic)
    sign_in_as(create(:user, :admin))
    put trash_topic_url(topic)
    assert topic.reload.trashed?
  end
end
