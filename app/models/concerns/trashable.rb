module Trashable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
    scope :trashed, -> { where.not(deleted_at: nil) }
  end

  def trash
    update_attribute :deleted_at, Time.now
  end

  def trashed?
    deleted_at.present?
  end

  def restore
    update_attribute :deleted_at, nil
  end
end
