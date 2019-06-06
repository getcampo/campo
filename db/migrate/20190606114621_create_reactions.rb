class CreateReactions < ActiveRecord::Migration[5.2]
  def change
    create_table :reactions do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.integer :type

      t.timestamps
    end
  end
end
