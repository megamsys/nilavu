class CreateAppsItems < ActiveRecord::Migration
  def self.up
    create_table :apps_items do |t|
      t.integer :cloud_app_id
      t.integer :product_id
      t.string :my_url

      t.timestamps
    end
    add_index :apps_items, :cloud_app_id
    add_index :apps_items, :product_id
  end

  def self.down
    remove_index :apps_items, :cloud_app_id
    remove_index :apps_items, :product_id
    drop_table :apps_items
  end
end
