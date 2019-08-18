class AttachmentUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/#{model.token}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png txt log gz zip pdf pptx docx xlsx)
  end

  def content_type_whitelist
    %w(
      image/jpeg
      image/gif
      image/png
      text/plain
      application/gzip
      application/zip
      application/pdf
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
      application/vnd.openxmlformats-officedocument.presentationml.presentation
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    )
  end

  def size_range
    1..10.megabytes
  end
end
