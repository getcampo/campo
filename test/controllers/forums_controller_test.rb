require 'test_helper'

class ForumsControllerTest < ActionDispatch::IntegrationTest
  test "should get forum index" do
    get forums_url
    assert_response :success
  end
end
