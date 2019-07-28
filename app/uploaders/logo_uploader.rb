class LogoUploader < ImageUploader
  version :thumb do
    process resize_to_fit: [nil, 160]
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_pack_path('media/images/logo.png')
  end
end
