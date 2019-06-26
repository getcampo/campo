require 'test_helper'

class SetupControllerTest < ActionDispatch::IntegrationTest
  test "should not visit setup if not enable" do
    @site.update setup_wizard_enabled: false
    get setup_path
    assert_redirected_to root_path
  end

  test "should visit setup if enable" do
    @site.update setup_wizard_enabled: true
    get setup_path
    assert_response :success
  end

  test "should generate default data after setup" do
    @site.update setup_wizard_enabled: true
    user = create(:user)
    sign_in_as user
    patch setup_path
    assert user.reload.admin?
  end
end
