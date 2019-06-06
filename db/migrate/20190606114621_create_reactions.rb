class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.integer :type

      t.timestamps

      t.index [:user_id, :post_id], unique: true
    end
  end
end
