class CloudBooksHistory < ActiveRecord::Base

attr_accessible :book_id, :book_name, :request_id, :status
 
  
  belongs_to :cloud_book, :foreign_key  => 'book_id' 


end
