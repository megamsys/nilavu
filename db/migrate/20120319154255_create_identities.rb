class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :users
      t.string :provider
      t.string :uid
      t.string :user_id
      t.timestamps
    end   
  end

  def down
    drop_table :identities
  end
end

