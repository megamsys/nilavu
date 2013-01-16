class CreateCloudIdentities < ActiveRecord::Migration
  def self.up
    create_table :cloud_identities do |t|
      t.string :url
	      t.string :account_name
	t.string :cloud_app_url
      t.integer :users_id
	t.string :status
	t.string :launch_time

      t.timestamps
    end
	add_index :cloud_identities, :users_id
  end
  def self.down
    remove_index :cloud_identities, :users_id
    drop_table :cloud_identities
  end
end
