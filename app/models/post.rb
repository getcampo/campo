class Post < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :user
  belongs_to :reply_to_post, class_name: 'Post', optional: true

  validates :body, presence: true

  before_create :generate_post_number

  def generate_post_number
    # TODO: lock
    self.post_number = (topic.posts.maximum(:post_number) || 0) + 1
  end
end
