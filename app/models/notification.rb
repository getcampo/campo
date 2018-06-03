class Notification < ApplicationRecord
  include Pageable

  belongs_to :user
  belongs_to :record, polymorphic: true

  validates :name, inclusion: { in: %w(comment reply mention) }

  scope :unread, -> { where(read: false) }
end
