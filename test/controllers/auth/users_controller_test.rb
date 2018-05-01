require 'test_helper'

class Auth::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new user page with identity" do
    get '/auth/test/callback'
    get new_auth_user_path
    assert_response :success
  end

   test "should not get new user page without identity" do
    get new_auth_user_path
    assert_redirected_to new_session_url
   end

   test "should create user and bind identity" do
    get '/auth/test/callback'
    assert_difference "User.count" do
      post auth_users_path, params: { user: { name: 'Foo', username: 'foo', email: 'foo@example.com' } }
    end
    assert_redirected_to root_url
   end
end
