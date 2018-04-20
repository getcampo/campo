require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new session page" do
    get new_session_url
    assert_response :success
  end

  test "should create identity and redirect to sign up" do
    assert_difference "Identity.count" do
      get auth_callback_url(provider: 'email', token: OmniAuth::Strategies::Email.token_for_email('account@example.com'))
    end
    assert_redirected_to new_user_path
  end

  test "should not create identity if token error" do
    assert_no_difference "Identity.count" do
      get auth_callback_url(provider: 'email', token: 'wrong')
    end
  end

  test "should sign in if identity belongs to user" do
    Identity.create(provider: 'email', uid: 'account@example.com')
    assert_no_difference "Identity.count" do
      get auth_callback_url(provider: 'email', token: OmniAuth::Strategies::Email.token_for_email('account@example.com'))
    end
  end
end
