require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should not get new user page without identity" do
    get sign_up_url
    assert_response :success
  end

  test "should create user" do
    assert_difference "User.count" do
      post users_url, params: { user: { name: 'Foo', username: 'foo', email: 'foo@example.com', password: 'password' }}
    end
    assert_redirected_to root_url
  end

  test "should validate user name" do
    post '/users/validate/name'
    assert_response :success
  end

  test "should validate user username" do
    post '/users/validate/username'
    assert_response :success
  end

  test "should validate user email" do
    post '/users/validate/email'
    assert_response :success
  end
  
end
