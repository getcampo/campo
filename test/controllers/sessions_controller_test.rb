require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new session page" do
    get sign_in_url
    assert_response :success
  end

  test "should sign in with username and password" do
    user = User.create(name: 'Foo', username: 'foo', email: 'foo@example.com', password: 'password')
    post session_path, params: { login: 'foo', password: 'password' }
    assert_redirected_to root_url
  end

  test "should sign in with email and password" do
    user = User.create(name: 'Foo', username: 'foo', email: 'foo@example.com', password: 'password')
    post session_path, params: { login: 'foo@example.com', password: 'password' }
    assert_redirected_to root_url
  end

  test "should not sign in with wrong password" do
    user = User.create(name: 'Foo', username: 'foo', email: 'foo@example.com', password: 'password')
    post session_path, params: { login: 'foo@example.com', password: 'wrong_password' }, xhr: true
    # render form error message
    assert_response :success
  end
end
