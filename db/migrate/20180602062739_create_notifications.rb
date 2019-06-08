class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.belongs_to :user, null: false
      t.belongs_to :record, null: false, polymorphic: true
      t.integer :type, null: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end
  end
end
