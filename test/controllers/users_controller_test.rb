require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should not get new user page without identity" do
    get new_user_url
    assert_redirected_to new_session_path
  end

  test "should get new user page with identity" do
    get auth_callback_url(provider: 'email', token: OmniAuth::Strategies::Email.token_for_email('account@example.com'))
    get new_user_url
    assert_response :success
  end

  test "should not get new user page if identity belongs_to user" do
    user = User.create(name: 'Name', username: 'username', email: 'account@example.com')
    user.identities.create(provider: 'email', uid: 'account@example.com')
    get auth_callback_url(provider: 'email', token: OmniAuth::Strategies::Email.token_for_email('account@example.com'))
    get new_user_path
    assert_redirected_to root_url
  end
end
