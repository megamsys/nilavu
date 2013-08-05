#Find all nodes by email
class FindNodesByEmail

  @queue = "nodes"
  
  #this returns a Megam::NodesCollection object
  def self.perform(show_predef={})
    Megam::Config[:email] = show_predef[:email]
    Megam::Config[:api_key] = show_predef[:api_key]   
  end

end