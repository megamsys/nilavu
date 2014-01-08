module Books
  extend self
  def availableBooks(userID)
  a=Array.new
  @node = FindNodesByEmail.perform
  @node.each do |n| 
   a << n.node_name
  end
    { "books" => a }
  end

end 
