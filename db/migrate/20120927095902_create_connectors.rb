class CreateConnectors < ActiveRecord::Migration
  def self.up
    create_table :connectors do |t|
      t.integer :cloud_app_id
      t.string :salesforce_consumer_key
      t.string :salesforce_consumer_secret
      t.string :description

      t.timestamps
    end
	add_index :connectors, :cloud_app_id
  end
  def self.down
	remove_index :connectors, :cloud_app_id
      drop_table :connectors
  end
end
