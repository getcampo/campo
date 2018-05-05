class Topic < ApplicationRecord
  has_many :comments
  belongs_to :board
  belongs_to :user

  validates :title, :content, presence: true

  before_create :set_activated_at

  def set_activated_at
    self.activated_at = current_time_from_proper_timezone
  end
end
