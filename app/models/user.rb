class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token
  has_one_attached :avatar
  has_many_attached :attachments

  has_many :identities
  has_many :topics
  has_many :comments
  has_many :notifications

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /\A[a-zA-Z][a-zA-Z0-9\-]+\z/ }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def password_reset_token
    token = SecureRandom.base58(32)
    Rails.cache.write "users/password_reset/#{token}", id, expires_in: 30.minutes
    token
  end

  def self.from_password_reset_token(token)
    find_by(id: Rails.cache.read("users/password_reset/#{token}"))
  end

  ADMIN_EMAILS = ENV['ADMIN_EMAILS'].split(',').map(&:strip)
  def admin?
    ADMIN_EMAILS.include?(email)
  end
end
