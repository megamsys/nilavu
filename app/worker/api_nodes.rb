class APINodes

   @queue = "nodes" 
  
   SANDBOX_HOST_OPTIONS = {
  :host => 'localhost',
  :port => 9000
}
  
  #returns Megam::Nodes
  def self.get
    sleep 10
  end

  def self.post(node={})
   n_post = SANDBOX_HOST_OPTIONS.merge(node)
     mg=Megam::API.new(n_post)
  end
  
  response = post.get_logs('thinker.megam.co')
end

