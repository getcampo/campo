class CreateTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.belongs_to :forum
      t.belongs_to :user
      t.string :title
      t.datetime :activated_at
      t.datetime :deleted_at

      t.timestamps

      t.index :activated_at
      t.index :deleted_at
    end
  end
end
