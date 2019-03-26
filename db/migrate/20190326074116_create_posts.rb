class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.belongs_to :topic
      t.belongs_to :user
      t.integer :post_number
      t.belongs_to :reply_to_post
      t.text :body
      t.belongs_to :edited_user
      t.datetime :edited_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
