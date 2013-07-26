class CloudBooksHistory < ActiveRecord::Base

attr_accessible :users_id, :book_id, :book_name, :request_id, :status
 
 belongs_to :user, :foreign_key  => 'users_id' 
 
  belongs_to :cloud_book, :foreign_key  => 'book_id' 


end
