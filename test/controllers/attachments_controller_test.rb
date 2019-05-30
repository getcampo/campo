require 'test_helper'

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  test "should create attachment" do
    sign_in_as create(:user)
    assert_difference "Attachment.count", +1 do
      post attachments_path, params: { attachment: { file: fixture_file_upload('files/logo.png', 'image/png') }}
    end
    assert_response :success
  end

  test "should get attachment" do
    attachment = Attachment.new user: create(:user)
    attachment.file.store!(File.open('test/fixtures/files/logo.png'))
    attachment.save
    get attachment_path(token: attachment.token, filename: attachment.file_identifier)
    assert_response :redirect
  end
end
