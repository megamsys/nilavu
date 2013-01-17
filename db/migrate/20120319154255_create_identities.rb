class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.references :users
      t.string :provider
      t.string :uid
      t.timestamps
    end
        add_index :identities, :users_id
  end

  def down
    remove_index :identities, :users_id
    drop_table :identities
  end
end
