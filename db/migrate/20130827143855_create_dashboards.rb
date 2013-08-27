class CreateDashboards < ActiveRecord::Migration
   def self.up
     create_table :dashboards do |t|
      t.string :name
      t.string :layout

      t.timestamps
    end
  end
  
  def self.down
     drop_table :dashboards
  end
end
