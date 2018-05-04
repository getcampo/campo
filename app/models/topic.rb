class Topic < ApplicationRecord
  belongs_to :board
  belongs_to :user

  validates :title, :content, presence: true
end
