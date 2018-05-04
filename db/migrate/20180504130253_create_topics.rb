class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.references :board
      t.references :user
      t.string :title, null: false
      t.text :content, null: false
      t.references :last_comment

      t.timestamps
    end
  end
end
