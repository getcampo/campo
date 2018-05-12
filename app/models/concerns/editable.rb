module Editable
  extend ActiveSupport::Concern

  included do
    belongs_to :edited_user, class_name: 'User', optional: true
  end

  def edited_by(user)
    self.edited_user = user
    self.edited_at = Time.now.utc
  end
end
