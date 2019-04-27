require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should generate default avatar after create" do
    user = create(:user)
    assert user.avatar.attached?
  end
end
