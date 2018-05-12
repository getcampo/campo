class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :topic
      t.belongs_to :user
      t.text :content, null: false
      t.boolean :trashed, default: false
      t.belongs_to :edited_user, index: false
      t.datetime :edited_at

      t.timestamps
    end
  end
end
