class Topic < ApplicationRecord
  include Trashable

  has_many :posts
  has_one :first_post, -> { where(number: 1) }, class_name: 'Post'
  has_many :subscriptions
  has_many :subscribed_users, -> { where(subscriptions: { status: 'subscribed' }) }, through: :subscriptions, source: :user
  has_many :ignored_users, -> { where(subscriptions: { status: 'ignored' }) }, through: :subscriptions, source: :user
  belongs_to :forum, touch: true
  belongs_to :user

  validates :title, presence: true

  accepts_nested_attributes_for :first_post, update_only: true

  before_create :set_activated_at

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end

  after_create :increment_topics_count
  after_trash :decrement_topics_count
  after_restore :increment_topics_count

  def increment_topics_count
    Forum.increment_counter :topics_count, forum_id, touch: true
  end

  def decrement_topics_count
    Forum.decrement_counter :topics_count, forum_id, touch: true
  end
end
