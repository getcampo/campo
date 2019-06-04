require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(name: 'Foo', username: 'foo', email: 'foo@example.com', password: '123456')
  end

  test "should get show page" do
    get password_reset_url
    assert_response :success
  end

  test "should get edit page with token" do
    get edit_password_reset_url(token: @user.password_reset_token)
    assert_response :success
  end

  test "should not get edit page with wrong token" do
    get edit_password_reset_url(token: 'wrong')
    assert_redirected_to password_reset_url
  end

  test "should update password with token" do
    patch password_reset_url(token: @user.password_reset_token), params: { user: { password: '654321', password_confirmation: '654321' } }
    assert_redirected_to sign_in_path
    assert @user.reload.authenticate('654321')
  end

  test "should not update password with wrong token" do
    patch password_reset_url(token: 'wrong'), params: { user: { password: '654321', password_confirmation: '654321' } }
    assert_redirected_to password_reset_url
  end
end
