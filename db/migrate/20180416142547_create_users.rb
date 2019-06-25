class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :email_verified, default: false
      t.string :password_digest, null: false
      t.string :avatar
      t.text :bio
      t.string :auth_token, null: false
      t.boolean :admin, default: false

      t.timestamps

      t.index :auth_token, unique: true
      t.index 'lower(username)', unique: true
      t.index 'lower(email)', unique: true
    end
  end
end
