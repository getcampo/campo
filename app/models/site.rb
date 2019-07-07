class Site < ApplicationRecord
  mount_uploader :logo, LogoUploader
  mount_uploader :icon, IconUploader
end
