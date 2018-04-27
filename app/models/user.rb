class User < ApplicationRecord
  has_secure_password

  has_many :identities

  validates :name, :username, :email, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /[a-zA-Z][a-zA-Z0-9\-]+/ }
end
