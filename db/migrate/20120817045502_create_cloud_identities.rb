class CreateCloudIdentities < ActiveRecord::Migration
  def self.up
    create_table :cloud_identities do |t|
      t.string :url
      t.integer :org_id

      t.timestamps
    end
	add_index :cloud_identities, :org_id
  end
def self.down
    remove_index :cloud_identities, :org_id
    drop_table :cloud_identities
  end
end
