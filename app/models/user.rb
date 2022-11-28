class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  has_many :identities
  has_many :topics
  has_many :posts
  has_many :notifications
  has_many :subscriptions
  has_many :subscribed_topics, -> { where(subscriptions: { status: 'subscribed' }) }, through: :subscriptions, source: :topic
  has_many :ignored_topics, -> { where(subscriptions: { status: 'ignored' }) }, through: :subscriptions, source: :topic
  has_many :reactions

  has_and_belongs_to_many :mentioned_posts, class_name: 'Post', join_table: 'mentions'

  has_many :attachments
  has_one_attached :avatar do |attachable|
    attachable.variant :normal, resize_to_fit: [160, 160]
  end

  enum role: {
    default: 0,
    admin: 1
  }

  USERNAME_REGEXP = /\A[a-zA-Z0-9][a-zA-Z0-9\-]{1,61}[a-zA-Z0-9]\z/

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates :username, format: { with: USERNAME_REGEXP }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  mattr_accessor :verifier
  self.verifier = Rails.application.message_verifier('User')

  def password_reset_token
    self.class.verifier.generate(id, purpose: :password_reset, expires_in: 5.minutes)
  end

  def self.from_password_reset_token(token)
    find verifier.verify(token, purpose: :password_reset)
  end

  DEFAULT_AVATAR_COLORS = %w(
    #007bff
    #6610f2
    #6f42c1
    #e83e8c
    #dc3545
    #fd7e14
    #ffc107
    #28a745
    #20c997
    #17a2b8
  )

  after_commit :generate_default_avatar, on: [:create]

  def generate_default_avatar
    temp_path = "#{Rails.root}/tmp/#{id}_default_avatar.png"
    system(*%W(convert -size 160x160 -annotate 0 #{username[0]} -font DejaVu-Sans -fill white -pointsize 100 -gravity Center xc:#{DEFAULT_AVATAR_COLORS.sample} #{temp_path}))
    File.open(temp_path) do |file|
      avatar.store! file
    end
    save
    FileUtils.rm temp_path
  end
end
