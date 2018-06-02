class Notification < ApplicationRecord
  include Pageable

  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :name, inclusion: { in: %w(comment reply) }
end
