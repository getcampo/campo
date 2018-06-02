class Topic < ApplicationRecord
  include Trashable, Editable, Pageable

  has_many :comments
  belongs_to :forum, counter_cache: true, touch: true
  belongs_to :user
  belongs_to :last_comment, class_name: 'Comment', optional: true

  validates :title, :content, presence: true

  before_create :set_activated_at

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end
end
