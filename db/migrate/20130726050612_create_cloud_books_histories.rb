class CreateCloudBooksHistories < ActiveRecord::Migration
   def self.up 
    create_table :cloud_books_histories do |t|      
      t.integer :book_id
      t.string :book_name
      t.string :request_id
      t.string :status

      t.timestamps
    end    
    add_index :cloud_books_histories, :book_id
  end
  
  def self.down    
    remove_index :cloud_books_histories, :book_id
    drop_table :cloud_books_histories
  end
end
