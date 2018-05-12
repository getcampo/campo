class Comment < ApplicationRecord
  include Trashable, Editable

  belongs_to :topic, touch: :activated_at, counter_cache: true
  belongs_to :user

  validates :content, presence: true
end
