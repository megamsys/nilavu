module Books
  extend self
  
   def availableBooks(userID)
     c = []
     #CloudBook.select("name").where(:users_id => userID).map { |n|  n.name }
     #puts c
    { "books" => CloudBook.select("name").where(:users_id => userID).map { |n|  n.name } } 
     
   end
  
end 