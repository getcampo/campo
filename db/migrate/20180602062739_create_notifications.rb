class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :type
      t.belongs_to :user
      t.belongs_to :record, polymorphic: true
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
