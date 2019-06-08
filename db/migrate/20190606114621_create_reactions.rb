class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.belongs_to :user, null: false, index: false
      t.belongs_to :post, null: false
      t.integer :type, null: false

      t.timestamps

      t.index [:user_id, :post_id], unique: true
    end
  end
end
