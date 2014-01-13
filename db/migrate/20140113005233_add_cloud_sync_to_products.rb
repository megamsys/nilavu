class AddCloudSyncToProducts < ActiveRecord::Migration
  def change
    add_column :products, :cloud_sync, :boolean
  end
end
