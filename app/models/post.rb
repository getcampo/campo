class Post < ApplicationRecord
  include Trashable

  belongs_to :topic, optional: true
  belongs_to :user
  belongs_to :edited_user, class_name: 'User', optional: true
  belongs_to :reply_to_post, class_name: 'Post', optional: true
  has_many :replied_posts, class_name: 'Post', foreign_key: 'reply_to_post_id'
  has_many :reactions

  validates :body, presence: true

  before_create :generate_number

  def generate_number
    # TODO: lock
    self.number = (topic.posts.unscope(where: :deleted_at).maximum(:number) || 0) + 1
  end

  def mentioned_users
    usernames = body.scan(/@([a-zA-Z]\w+)/).flatten
    User.where(username: usernames)
  end

  def self.prepare_search_data(text)
    segment = CppjiebaRb.segment(text, mode: :mix)
    CppjiebaRb.filter_stop_word(segment).join(' ')
  end

  def self.prepare_search_query(text)
    segment = CppjiebaRb.segment(text, mode: :mix)
    CppjiebaRb.filter_stop_word(segment).join(' & ')
  end

  after_commit :enqueu_update_search_job, if: :saved_change_to_body?

  def enqueu_update_search_job
    PostUpdateSearchDataJob.perform_later(self)
  end

  def update_search_data
    strip_body = ApplicationController.helpers.markdown_strip(body)
    raw_data = number == 0 ? (topic.title + strip_body) : strip_body
    data = Post.prepare_search_data(raw_data)
    Post.where(id: id).update_all(Post.sanitize_sql(["search_data = to_tsvector(?)", data]))
  end

  scope :search, -> (query) {
    where("search_data @@ to_tsquery(?)", Post.prepare_search_query(query))
  }

  after_create :increment_posts_count
  after_trash :decrement_posts_count
  after_restore :increment_posts_count

  def increment_posts_count
    Topic.increment_counter :posts_count, topic_id, touch: true
  end

  def decrement_posts_count
    Topic.decrement_counter :posts_count, topic_id, touch: true
  end
end
