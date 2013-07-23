class APIPredefClouds

  attr_accessor :worker_queue
  
  def initialize
    @worker_queue = "predefclouds"
  end

  #returns Megam::PredefClouds
  def get
    sleep 10
  end

  def post
    sleep 10
  end

end