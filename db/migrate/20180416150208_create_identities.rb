class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.references :user
      t.string :uid
      t.string :provider

      t.timestamps

      t.index [:uid, :provider], unique: true
    end
  end
end
