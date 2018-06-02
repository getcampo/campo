require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as(create(:user, :admin))
    get admin_root_url
    assert_response :success
  end
end
