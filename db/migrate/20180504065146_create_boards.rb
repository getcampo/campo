class CreateBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :boards do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :topics_count, default: 0

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE UNIQUE INDEX index_boards_on_lowercase_slug
            ON users USING btree (LOWER(username));
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP INDEX index_boards_on_lowercase_slug;
        SQL
      end
    end
  end
end
