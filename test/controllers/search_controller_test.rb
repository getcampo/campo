require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_url(query: 'ruby')
    assert_response :success
  end
end
