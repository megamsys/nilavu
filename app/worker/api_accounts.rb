class APIAccounts

  @queue = "accounts"  
  
  SANDBOX_HOST_OPTIONS = {
  :host => 'localhost',
  :port => 9000
}
  
  #returns Megam::Accounts
  def self.get
  sleep 10    
  end
  
  def self.post(user_details={})
     a_post = SANDBOX_HOST_OPTIONS.merge(user_details)
     mg=Megam::API.new(a_post)
  end
  
  response = post.post_auth()

end