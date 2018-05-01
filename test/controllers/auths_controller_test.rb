require 'test_helper'

class AuthsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect_to new auth user" do
    get '/auth/test/callback'
    assert_redirected_to new_auth_user_path
  end

  test "should login user" do
    user = User.create(name: 'Foo', username: 'foo', email: 'foo@example.com', password: '123456')
    identity = Identity.create(user: user, provider: 'test', uid: '1')
    get '/auth/test/callback'
    assert_redirected_to root_url
  end
end
