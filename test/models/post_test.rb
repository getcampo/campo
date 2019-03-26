require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should generate post_number" do
    post = create(:post)
    assert_equal 1, post.number
  end
end
