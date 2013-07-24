class APINodes

   @queue = "nodes" 
  
  #returns Megam::Nodes
  def self.get
    sleep 10
  end

  def self.post(hash={})
    "#{hash['predefname']} created"    
  end

end