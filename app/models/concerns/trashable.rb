module Trashable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }
    scope :trashed, -> { where.not(deleted_at: nil) }
    define_model_callbacks :trash, :restore
  end

  def trash
    run_callbacks :trash do
      update_attribute :deleted_at, Time.now
    end
  end

  def trashed?
    deleted_at.present?
  end

  def restore
    run_callbacks :restore do
      update_attribute :deleted_at, nil
    end
  end
end
