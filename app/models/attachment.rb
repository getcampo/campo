class Attachment < ApplicationRecord
  belongs_to :user

  mount_uploader :file, AttachmentUploader

  before_create :set_token

  # Do not use has_secure_token because it's late for file store
  def set_token
    self.token = SecureRandom.base58(24)
  end

  before_save :set_meta_data

  def set_meta_data
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.byte_size = file.file.size
    end
  end

  def uri
    "/attachments/#{token}/#{file_identifier}"
  end
end
