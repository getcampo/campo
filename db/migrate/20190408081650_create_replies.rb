class CreateReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :replies, id: false do |t|
      t.belongs_to :from_post
      t.belongs_to :to_post
    end
  end
end
