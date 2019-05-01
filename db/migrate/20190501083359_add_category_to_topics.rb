class AddCategoryToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :category_id, :integer
    add_column :topics, :category_ancestor_ids, :integer, array: true
    add_index :topics, :category_id
    add_index :topics, :category_ancestor_ids, using: 'gin'
  end
end
