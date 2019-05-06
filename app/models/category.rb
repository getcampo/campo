class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :topics
  has_many :children, class_name: 'Category', foreign_key: 'parent_id'

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { case_sensitive: false }

  scope :top_level, -> { where(parent_id: nil) }

  def ancestors
    Category.find_by_sql(["
      WITH RECURSIVE result AS (
        SELECT categories.* FROM categories WHERE id = ?
        UNION
        SELECT categories.* FROM result, categories where result.parent_id = categories.id
      )
      SELECT * FROM result
    ", id])
  end

  def descendant_topics
    Topic.where("category_ancestor_ids @> array[?]", [id])
  end
end
