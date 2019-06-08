class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.belongs_to :forum, null: false
      t.belongs_to :user, null: false
      t.string :title, null: false
      t.datetime :activated_at, null: false
      t.datetime :deleted_at

      t.timestamps

      t.index :activated_at
      t.index :deleted_at
    end
  end
end
