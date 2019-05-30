class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fit: [160, 160]
  end

  def extension_whitelist
    %w(jpg jpeg png)
  end

  def content_type_whitelist
    ['image/jpeg', 'image/png']
  end
end
