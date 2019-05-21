require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "should create post" do
    sign_in_as create(:user)

    topic = create(:topic)
    assert_enqueued_with(job: PostNotificationJob) do
      assert_difference "topic.posts.count" do
        post posts_url, params: { post: { topic_id: topic.id, body: 'body' } }, xhr: true
      end
    end
    assert_response :success
  end

  test "should get edit page" do
    post = create(:post)
    sign_in_as post.user
    get edit_post_path(post), xhr: true
    assert_response :success
  end

  test "should update post" do
    post = create(:post)
    sign_in_as post.user
    patch post_url(post), params: { post: { content: 'Change'} }, xhr: true
    assert_response :success
  end

  test "should trash post" do
    post = create(:post)
    sign_in_as post.user
    assert_difference "Post.count", -1 do
      put trash_post_url(post), xhr: true
    end
    assert_response :success
    assert post.reload.trashed?
  end
end
