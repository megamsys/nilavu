class CreateAppsItems < ActiveRecord::Migration
  def self.up
    create_table :apps_items do |t|
      t.integer :cloud_app_id
      t.string :name
      t.string :url
      t.string :my_url

      t.timestamps
    end
    add_index :apps_items, :cloud_app_id
  end

  def self.down
    remove_index :apps_items, :cloud_app_id
    drop_table :apps_items
  end
end
