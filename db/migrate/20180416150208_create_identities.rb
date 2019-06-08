class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.references :user
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :name

      t.timestamps

      t.index [:uid, :provider], unique: true
    end
  end
end
