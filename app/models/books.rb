module Books
  extend self
  def availableBooks(userID)
  a=Array.new
  @node = FindNodesByEmail.perform
  if @node.class == Megam::Error
    { "books" => ["You have no books"] }
      else
  @node.each do |n|
   a << n.node_name
  end
    { "books" => a }
  end
end
end  
