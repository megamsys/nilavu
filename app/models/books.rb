module Books
  extend self
  
   def availableBooks(userID)
     c = []
     c << { "nodes" => CloudBook.select("name").where(:users_id => userID) } 
     puts c    
     c
   end
  
end 