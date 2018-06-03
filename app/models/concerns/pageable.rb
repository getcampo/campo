module Pageable
  extend ActiveSupport::Concern

  included do
    scope :page, -> (page) { offset(page.to_i * 25).limit(25) }
  end
end
