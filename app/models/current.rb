class Current < ActiveSupport::CurrentAttributes
  attribute :user, :identity, :site
end
