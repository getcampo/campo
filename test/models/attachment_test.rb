require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  test "should generate uri" do
    attachment = create(:attachment)
    assert_equal "/attachments/#{attachment.token}/#{attachment.file_identifier}", attachment.uri
  end
end
