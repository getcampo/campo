require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should get ancestors" do
    parent = create(:category)
    child_1 = create(:category, parent: parent)
    child_2 = create(:category, parent: child_1)
    assert_equal [child_1, parent], child_1.ancestors
    assert_equal [child_2, child_1, parent], child_2.ancestors
  end

  test "should get descendant_topics" do
    parent = create(:category)
    child = create(:category, parent: parent)
    topic = create(:topic, category: child)
    assert parent.descendant_topics.include?(topic)
    assert child.descendant_topics.include?(topic)
  end
end
