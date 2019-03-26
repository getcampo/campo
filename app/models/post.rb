class Post < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :user
  belongs_to :reply_to_post, class_name: 'Post', optional: true
  belongs_to :edited_user, class_name: 'User', optional: true

  validates :body, presence: true

  before_create :generate_number

  def generate_number
    # TODO: lock
    self.number = (topic.posts.maximum(:number) || 0) + 1
  end
end
