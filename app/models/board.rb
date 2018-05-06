class Board < ApplicationRecord
  has_many :topics, counter_cache: true

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { case_sensitive: false }

  def to_param
    slug
  end
end
