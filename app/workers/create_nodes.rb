class CreateNodes

  @queue = "nodes"
  
  #this returns a Megam::Account object
  def self.perform(new_node={})
    Megam::Config[:email] = new_node[:email]
    Megam::Config[:api_key] = new_node[:api_key]    
    Megam::Node.create(new_node)
  end

end