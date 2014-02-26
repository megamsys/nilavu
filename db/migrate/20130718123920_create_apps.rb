class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.integer :users_id      
      t.string :name
      t.string :predef_name
      t.string :predef_cloud_name
      t.string :app_defn_ids
      t.string :bolt_defn_ids
      t.string :domain_name
	t.string :book_type
	t.string :group_name
	t.string :cloud_name
      t.timestamps
    end
    add_index :apps, :users_id
  end

  def self.down
    remove_index :apps, :users_id
    drop_table :apps
  end
end
