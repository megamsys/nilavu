class APIPredefs

  attr_accessor :worker_queue
  
  def initialize
    @worker_queue = "predefs"
  end

  #returns Megam::Predefs
  def get
    sleep 10
  end

  

end