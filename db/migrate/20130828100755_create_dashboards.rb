class CreateDashboards < ActiveRecord::Migration
 def self.up
    create_table :dashboards do |t|
      t.string :name
      t.string :layout
      t.integer :user_id

      t.timestamps
    end
  end
  
  def self.down
    remove_index :dashboards, :user_id
    drop_table :dashboards
  end
end
