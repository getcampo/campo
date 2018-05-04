require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should create comment" do
    sign_in_as users(:user)

    assert_difference "topics(:topic).comments.count" do
      post comments_url, params: { comment: { topic_id: topics(:topic).id, content: 'Content' } }, xhr: true
    end
    assert_response :success
  end

  test "should get edit page" do
    sign_in_as users(:user)
    get edit_comment_path(comments(:comment))
    assert_response :success
  end

  test "should update comment" do
    sign_in_as users(:user)
    patch comment_url(comments(:comment)), params: { comment: { content: 'Change'} }
    assert_redirected_to topic_path(comments(:comment).topic, anchor: "comment-#{comments(:comment).id}")
  end
end
