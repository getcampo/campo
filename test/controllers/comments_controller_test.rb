require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should create comment" do
    sign_in_as create(:user)

    topic = create(:topic)
    assert_difference "topic.comments.count" do
      post comments_url, params: { comment: { topic_id: topic.id, content: 'Content' } }, xhr: true
    end
    assert_response :success
  end

  test "should get edit page" do
    comment = create(:comment)
    sign_in_as comment.user
    get edit_comment_path(comment)
    assert_response :success
  end

  test "should update comment" do
    comment = create(:comment)
    sign_in_as comment.user
    patch comment_url(comment), params: { comment: { content: 'Change'} }
    assert_redirected_to topic_path(comment.topic, anchor: "comment-#{comment.id}")
  end

  test "should trash comment by admin" do
    comment = create(:comment)
    sign_in_as create(:user, :admin)
    put trash_comment_url(comment), xhr: true
    assert comment.reload.trashed?
  end

  test "should not trash comment by user" do
    comment = create(:comment)
    sign_in_as comment.user
    put trash_comment_url(comment), xhr: true
    assert_not comment.reload.trashed?
  end
end
