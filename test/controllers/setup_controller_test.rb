require 'test_helper'

class SetupControllerTest < ActionDispatch::IntegrationTest
  test "should not visit setup if site exists" do
    get setup_path
    assert_redirected_to root_path
  end

  test "should visit setup if site not exists" do
    @site.destroy
    get setup_path
    assert_response :success
  end

  test "should generate default data after setup" do
    @site.destroy
    user = create(:user)
    sign_in_as user
    assert_difference "Site.count" do
      patch setup_path
    end
    assert user.reload.admin?
  end
end
