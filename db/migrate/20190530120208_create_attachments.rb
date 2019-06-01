class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.belongs_to :user
      t.string :token
      t.string :file
      t.string :content_type
      t.integer :byte_size

      t.timestamps

      t.index :token, unique: true
    end
  end
end
