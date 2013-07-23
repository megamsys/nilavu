class APIAccounts

  attr_accessor :worker_queue
  
  def initialize
    @worker_queue = "accounts"
  end
  
  #returns Megam::Accounts
  def get
  sleep 10    
  end
  
  def post
  sleep 10    
  end

end