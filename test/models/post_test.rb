require 'test_helper'

class PostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "should generate post_number" do
    post = create(:post)
    assert_equal 1, post.number
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

  test "should update search data" do
    post = create(:post)
    post.update_search_data
    assert_not_nil post.reload.search_data
  end

  test "should update forum topics counter" do
    topic = create(:topic)
    assert_difference "topic.reload.posts_count", 1 do
      create(:post, topic: topic)
    end

    post = topic.posts.last

    assert_difference "topic.reload.posts_count", -1 do
      post.trash
    end

    assert_difference "topic.reload.posts_count", 1 do
      post.restore
    end
  end
end
