class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :topic
      t.references :user
      t.text :content, null: false

      t.timestamps
    end
  end
end
