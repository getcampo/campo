class Post < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :user
  belongs_to :edited_user, class_name: 'User', optional: true

  has_and_belongs_to_many :reply_to_posts, class_name: 'Post', join_table: 'replies', foreign_key: 'from_post_id', association_foreign_key: 'to_post_id'
  has_and_belongs_to_many :reply_from_posts, class_name: 'Post', join_table: 'replies', foreign_key: 'to_post_id', association_foreign_key: 'from_post_id'

  has_and_belongs_to_many :mentioned_users, class_name: 'User', join_table: 'mentions'

  validates :body, presence: true

  before_create :generate_number

  def generate_number
    # TODO: lock
    self.number = (topic.posts.maximum(:number) || 0) + 1
  end

  before_save :extract_reply_relation

  def extract_reply_relation
    user_ids = []
    post_ids = []
    body.scan(/@([a-zA-Z][a-zA-Z0-9\-]+)(#(\d+))?/) do |username, _, post_id|
      user = User.find_by(username: username)
      if user
        user_ids.push user.id
        if user.posts.where(id: post_id).exists?
          post_ids.push post_id
        end
      end
    end
    self.mentioned_user_ids = user_ids
    self.reply_to_post_ids = post_ids
  end

  def create_post_notifications
    topic.user.notifications.create(type: 'post', record: self)
  end

  def create_mention_notifications
    mentioned_users.each do |user|
      user.notifications.create(type: 'mention', record: self)
    end
  end
end
