class Board < ApplicationRecord
  validates :slug, uniqueness: { case_sensitive: false }
end
