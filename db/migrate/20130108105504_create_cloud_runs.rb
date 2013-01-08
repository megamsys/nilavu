class CreateCloudRuns < ActiveRecord::Migration
  def self.up
    create_table :cloud_runs do |t|
      t.string :name
	t.integer :users_id
      t.string :description
      t.string :log
      t.string :status
      t.string :launch_time

      t.timestamps
    end
  end
  
  def self.down
	drop_table :cloud_runs
  end
end
