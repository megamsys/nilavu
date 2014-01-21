class AddCloudNameToCloudBooks < ActiveRecord::Migration
  def self.up
    change_table :cloud_books do |t|
      t.string :cloud_name
    end
  end

  def self.down
    remove_column :cloud_books, :cloud_name
  end   
end
