class Forum < ApplicationRecord
  has_many :topics

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { case_sensitive: false }
end
