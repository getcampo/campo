class Topic < ApplicationRecord
  has_many :comments
  belongs_to :board
  belongs_to :user

  validates :title, :content, presence: true
end
