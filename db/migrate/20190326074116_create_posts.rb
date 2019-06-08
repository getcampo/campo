class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.belongs_to :topic, null: false
      t.belongs_to :user, null: false
      t.integer :number, null: false
      t.belongs_to :reply_to_post
      t.text :body, null: false
      t.belongs_to :edited_user
      t.datetime :edited_at
      t.datetime :deleted_at

      t.timestamps

      t.index :deleted_at
    end
  end
end
