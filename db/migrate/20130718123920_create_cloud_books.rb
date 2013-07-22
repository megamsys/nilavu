class CreateCloudBooks < ActiveRecord::Migration
  def self.up
    create_table :cloud_books do |t|
      t.integer :users_id
      t.string :name
      t.string :platform_app
      t.string :deps_scm
      t.string :deps_war
      t.string :domain_name

      t.timestamps
    end
  end

  def self.down
    drop_table :cloud_books
  end
end
