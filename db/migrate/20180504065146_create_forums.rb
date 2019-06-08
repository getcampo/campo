class CreateForums < ActiveRecord::Migration[5.2]
  def change
    create_table :forums do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :topics_count, null: false, default: 0

      t.timestamps

      t.index 'lower(slug)', unique: true
    end
  end
end
