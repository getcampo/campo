class Topic < ApplicationRecord
  include Trashable, Editable, Mentionable

  has_many :comments
  has_many :posts
  has_one :first_post, -> { where(number: 1) }, class_name: 'Post'
  belongs_to :forum, counter_cache: true, touch: true
  belongs_to :user
  belongs_to :last_comment, class_name: 'Comment', optional: true

  validates :title, presence: true

  accepts_nested_attributes_for :first_post, update_only: true

  before_create :set_activated_at
  after_commit :enqueue_create_notifications, on: [:create]

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end

  def enqueue_create_notifications
    TopicNotificationJob.perform_later(self)
  end

  def create_notifications
  end
end
