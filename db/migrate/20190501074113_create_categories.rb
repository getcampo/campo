class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.belongs_to :parent
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps

      t.index 'lower(slug)', unique: true
    end
  end
end
