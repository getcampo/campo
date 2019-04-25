require 'test_helper'

class Profile::TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = create(:user)
    create(:topic, user: user)
    get profile_root_path(username: user.username)
    assert_response :success
  end
end
