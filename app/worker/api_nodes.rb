class APINodes

  attr_accessor :worker_queue
  
  def initialize
    @worker_queue = "nodes"
  end
  
  #returns Megam::Nodes
  def get
    sleep 10
  end

  def post
    sleep 10
  end

end