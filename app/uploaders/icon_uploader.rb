class IconUploader < ImageUploader
  version :thumb do
    process resize_to_fill: [160, 160]
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_pack_path('media/images/icon.png')
  end
end
