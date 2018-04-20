class Identity < ApplicationRecord
  belongs_to :user, optional: true
end
