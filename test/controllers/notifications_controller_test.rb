require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "auto mark all as read" do
    user = create(:user)
    user.notifications.create(name: 'comment', record: create(:comment))
    sign_in_as user
    get notifications_url
    assert_response :success
    assert_equal 0, user.notifications.unread.count
  end
end
