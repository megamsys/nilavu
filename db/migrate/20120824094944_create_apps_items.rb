class CreateAppsItems < ActiveRecord::Migration
  def self.up
    create_table :apps_items do |t|
      t.integer :users_id
	t.integer :cloud_identity_id
      t.integer :product_id
	t.string :app_name
      t.string :my_url
	t.string :federated_identity_type

      t.timestamps
    end
    add_index :apps_items, :users_id
    add_index :apps_items, :product_id
    add_index :apps_items, :cloud_identity_id
  end

  def self.down
    remove_index :apps_items, :users_id
    remove_index :apps_items, :product_id
    remove_index :apps_items, :cloud_identity_id
    drop_table :apps_items
  end
end
