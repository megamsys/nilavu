class CreateAppsHistories < ActiveRecord::Migration
   def self.up 
    create_table :apps_histories do |t|      
      t.integer :book_id
      t.string :book_name
      t.string :request_id
      t.string :status
      t.string :group_name

      t.timestamps
    end    
    add_index :apps_histories, :book_id
  end
  
  def self.down    
    remove_index :apps_histories, :book_id
    drop_table :apps_histories
  end
end
