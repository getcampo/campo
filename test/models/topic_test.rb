require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "should update forum topics counter" do
    forum = create(:forum)
    assert_difference "forum.reload.topics_count", 1 do
      create(:topic, forum: forum)
    end

    topic = forum.topics.last

    assert_difference "forum.reload.topics_count", -1 do
      topic.trash
    end

    assert_difference "forum.reload.topics_count", 1 do
      topic.restore
    end
  end
end
