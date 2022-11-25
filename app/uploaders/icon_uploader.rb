class IconUploader < ImageUploader
  version :thumb do
    process resize_to_fill: [160, 160]
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('icon.png')
  end
end
