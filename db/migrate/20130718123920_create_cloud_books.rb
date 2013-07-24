class CreateCloudBooks < ActiveRecord::Migration
  def self.up
    create_table :cloud_books do |t|
      t.integer :users_id      
      t.string :predef_name
      t.string :predef_cloud_name
      t.string :deps_scm
      t.string :deps_war
      t.string :domain_name
      t.timestamps
    end
    add_index :cloud_books, :users_id
  end

  def self.down
    remove_index :cloud_books, :users_id
    drop_table :cloud_books
  end
end
