class AddGroupNameToCloudBooks < ActiveRecord::Migration
def self.up
    change_table :cloud_books do |t|
      t.string :group_name
    end
  end

  def self.down
    remove_column :cloud_books, :group_name
  end 
end
