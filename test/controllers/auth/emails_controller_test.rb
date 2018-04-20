require 'test_helper'

class Auth::EmailsControllerTest < ActionDispatch::IntegrationTest
  test "should get new email auth page" do
    get auth_email_url
    assert_response :success
  end

  test "should send email auth email" do
    assert_difference 'ActionMailer::Base.deliveries.size' do
      post auth_email_url, params: { email: 'account@example.com' }
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal 'account@example.com', email.to[0]
  end
end
