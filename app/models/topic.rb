class Topic < ApplicationRecord
  include Trashable, Editable

  has_many :comments
  belongs_to :forum, counter_cache: true
  belongs_to :user
  belongs_to :last_comment, class_name: 'Comment', optional: true

  validates :title, :content, presence: true

  before_create :set_activated_at

  scope :page, -> (page) { offset(page.to_i * 25).limit(25) }

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end
end
