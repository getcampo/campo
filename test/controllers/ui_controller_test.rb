require 'test_helper'

class UiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ui_index_url
    assert_response :success
  end

end
