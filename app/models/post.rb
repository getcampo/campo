class Post < ApplicationRecord
  include Trashable

  belongs_to :topic, optional: true
  belongs_to :user
  belongs_to :edited_user, class_name: 'User', optional: true
  belongs_to :reply_to_post, class_name: 'Post', optional: true
  has_many :replied_posts, class_name: 'Post', foreign_key: 'reply_to_post_id'

  has_and_belongs_to_many :reply_to_posts, class_name: 'Post', join_table: 'replies', foreign_key: 'from_post_id', association_foreign_key: 'to_post_id'
  has_and_belongs_to_many :reply_from_posts, class_name: 'Post', join_table: 'replies', foreign_key: 'to_post_id', association_foreign_key: 'from_post_id'

  has_and_belongs_to_many :mentioned_users, class_name: 'User', join_table: 'mentions'

  validates :body, presence: true

  before_create :generate_number

  def generate_number
    # TODO: lock
    self.number = (topic.posts.unscope(where: :deleted_at).maximum(:number) || 0) + 1
  end

  after_commit :extract_reply_relation

  def extract_reply_relation
    user_ids = []
    post_ids = []
    body.scan(/@([a-zA-Z]\w+)(#(\d+))?/) do |username, _, post_id|
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

  def self.prepare_search_data(text)
    segment = CppjiebaRb.segment(text, mode: :mix)
    CppjiebaRb.filter_stop_word(segment).join(' ')
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
    where("search_data @@ to_tsquery(?)", Post.prepare_search_data(query))
  }
end
