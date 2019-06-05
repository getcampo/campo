require 'test_helper'

class PostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should generate post_number" do
    post = create(:post)
    assert_equal 1, post.number
  end

  test "should extract post reply relation from body" do
    post = create(:post)
    reply_post = create(:post, body: "@#{post.user.username}##{post.id}")
    assert reply_post.reply_to_posts.include?(post)
    assert post.reply_from_posts.include?(reply_post)
    assert reply_post.mentioned_users.include?(post.user)
    assert post.user.mentioned_posts.include?(reply_post)
  end

  test "should extract mention only reply from body" do
    post = create(:post)
    reply_post = create(:post, body: "@#{post.user.username}")
    assert reply_post.mentioned_users.include?(post.user)
    assert post.user.mentioned_posts.include?(reply_post)
  end

  test "should enequeu update search data job" do
    assert_enqueued_with job: PostUpdateSearchDataJob do
      create(:post)
    end

    post = create(:post)
    assert_enqueued_with job: PostUpdateSearchDataJob do
      post.update(body: 'changed')
    end
  end

  test "should update search do" do
    post = create(:post)
    post.update_search_data
    assert_not_nil post.reload.search_data
  end
end
