require 'test_helper'

class Profile::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = create(:user)
    create(:post, user: user)
    get profile_posts_path(username: user.username)
    assert_response :success
  end
end
