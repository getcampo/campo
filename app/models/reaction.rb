class Reaction < ApplicationRecord
  self.inheritance_column = '_type_disabled'

  belongs_to :user
  belongs_to :post, touch: true

  enum type: {
    like: 0,
    dislike: 1
  }
end
