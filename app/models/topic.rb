class Topic < ApplicationRecord
  include Trashable

  has_many :posts
  has_one :first_post, -> { where(number: 1) }, class_name: 'Post'
  has_many :subscriptions
  has_many :subscribed_users, -> { where(subscriptions: { status: 'subscribed' }) }, through: :subscriptions, source: :user
  has_many :ignored_users, -> { where(subscriptions: { status: 'ignored' }) }, through: :subscriptions, source: :user
  belongs_to :category, touch: true, optional: true
  belongs_to :user
  belongs_to :last_comment, class_name: 'Comment', optional: true

  validates :title, presence: true

  accepts_nested_attributes_for :first_post, update_only: true

  before_create :set_activated_at

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end

  before_save :set_category_ancestor_ids

  def set_category_ancestor_ids
    if category
      self.category_ancestor_ids = category.ancestors.pluck(:id)
    end
  end
end
