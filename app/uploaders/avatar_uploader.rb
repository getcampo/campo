class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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

  def filename
    if original_filename
      "#{secure_token}.#{file.extension}"
    end
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.base58)
  end
end
