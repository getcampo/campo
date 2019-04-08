class Notification < ApplicationRecord
  self.inheritance_column = '_type_disabled'

  belongs_to :user
  belongs_to :record, polymorphic: true

  enum type: {
    post: 0,
    reply: 1,
    mention: 2
  }

  scope :unread, -> { where(read: false) }
end
