class AddCloudSyncToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :cloud_sync, :boolean
  end
  def self.down
    remove_column :products, :cloud_sync, :boolean
  end 
end
