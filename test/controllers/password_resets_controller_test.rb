require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get show page" do
    get password_reset_url
    assert_response :success
  end
end
