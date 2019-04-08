require 'test_helper'

class PostTest < ActiveSupport::TestCase
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
end
