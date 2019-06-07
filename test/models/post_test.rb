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

  test "should update search do" do
    post = create(:post)
    post.update_search_data
    assert_not_nil post.reload.search_data
  end
end
