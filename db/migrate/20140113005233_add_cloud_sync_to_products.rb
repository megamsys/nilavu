class AddCloudSyncToProducts < ActiveRecord::Migration
def self.up
    change_table :products do |t|
      t.boolean :cloud_sync
    end
  end

  def self.down
    remove_column :products, :cloud_sync
  end   
end
