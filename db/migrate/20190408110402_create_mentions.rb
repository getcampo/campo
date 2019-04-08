class CreateMentions < ActiveRecord::Migration[5.2]
  def change
    create_table :mentions, id: false do |t|
      t.belongs_to :post
      t.belongs_to :user
    end
  end
end
