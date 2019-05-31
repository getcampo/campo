require 'test_helper'

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  test "should create attachment" do
    sign_in_as create(:user)
    assert_difference "Attachment.count", +1 do
      post attachments_path, params: { attachment: { file: fixture_file_upload('files/logo.png', 'image/png') }}
    end
    assert_response :success
  end
end
