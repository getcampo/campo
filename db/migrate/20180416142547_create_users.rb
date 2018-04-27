class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :email_verified, default: false
      t.string :password_digest, null: false
      t.text :bio

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE UNIQUE INDEX index_users_on_lowercase_username
            ON users USING btree (LOWER(username));
          CREATE UNIQUE INDEX index_users_on_lowercase_email
            ON users USING btree (LOWER(email));
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP INDEX index_users_on_lowercase_username;
          DROP INDEX index_users_on_lowercase_email;
        SQL
      end
    end
  end
end
