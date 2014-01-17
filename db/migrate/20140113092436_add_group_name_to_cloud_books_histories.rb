class AddGroupNameToCloudBooksHistories < ActiveRecord::Migration
  def self.up
    change_table :cloud_books_histories do |t|
      t.string :group_name
    end
  end

  def self.down
    remove_column :cloud_books_histories, :group_name
  end 
end
