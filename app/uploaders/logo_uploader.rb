class LogoUploader < ImageUploader
  version :thumb do
    process resize_to_fit: [nil, 160]
  end
end
