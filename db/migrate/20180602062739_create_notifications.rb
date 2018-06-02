class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :name
      t.belongs_to :user
      t.belongs_to :source, polymorphic: true
      t.boolean :read, default: false
      t.json :data

      t.timestamps
    end
  end
end
