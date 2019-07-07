class IconUploader < ImageUploader
  version :thumb do
    process resize_to_fill: [160, 160]
  end
end
