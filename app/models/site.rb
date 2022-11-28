class Site < ApplicationRecord
  has_one_attached :icon do |attachable|
    attachable.variant :normal, resize_to_fit: [160, 160]
  end

  has_one_attached :logo do |attachable|
    attachable.variant :normal, resize_to_limit: [320, 320]
  end

  def self.create_default
    create(
      name: "Campo"
    )
  end
end
