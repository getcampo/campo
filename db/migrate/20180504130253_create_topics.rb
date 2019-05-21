class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.belongs_to :forum
      t.belongs_to :user
      t.string :title, null: false
      t.integer :comments_count, default: 0
      t.belongs_to :last_comment, index: false
      t.datetime :activated_at, null: false
      t.belongs_to :edited_user, index: false
      t.datetime :edited_at
      t.datetime :deleted_at

      t.timestamps

      t.index :activated_at
      t.index :deleted_at
    end
  end
end
