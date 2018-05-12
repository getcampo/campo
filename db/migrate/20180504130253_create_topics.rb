class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.references :forum
      t.references :user
      t.string :title, null: false
      t.text :content, null: false
      t.integer :comments_count, default: 0
      t.datetime :activated_at, null: false
      t.boolean :trashed, default: false

      t.timestamps

      t.index :activated_at
    end
  end
end
