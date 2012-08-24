class CreateCloudApps < ActiveRecord::Migration
  def self.up
    create_table :cloud_apps do |t|
      t.integer :org_id
      t.string :name

      t.timestamps
    end
	add_index :cloud_apps, :org_id
  end
  def self.down
    remove_index :cloud_apps, :org_id
    drop_table :cloud_apps
  end
end
