module Books
  extend self
  def availableBooks(userID)
    c = []
    { "books" => CloudBook.select("name").where(:users_id => userID).map { |n|  n.name } }
  end

end 