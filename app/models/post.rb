class Post < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :user
  belongs_to :edited_user, class_name: 'User', optional: true

  has_and_belongs_to_many :reply_to_posts, class_name: 'Post', join_table: 'replies', foreign_key: 'from_post_id', association_foreign_key: 'to_post_id'
  has_and_belongs_to_many :reply_from_posts, class_name: 'Post', join_table: 'replies', foreign_key: 'to_post_id', association_foreign_key: 'from_post_id'

  validates :body, presence: true

  before_create :generate_number

  def generate_number
    # TODO: lock
    self.number = (topic.posts.maximum(:number) || 0) + 1
  end
end
