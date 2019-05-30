class AttachmentUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # TODO: more file type
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def content_type_whitelist
    ['image/jpeg', 'image/gif', 'image/png']
  end
end
