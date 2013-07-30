class APIAccounts

  @queue = "accounts"
  
  def self.perform(new_account={})
    mg=Megam::API.new(Megam::Config[:email], Megam::Config[:api_key])
    mg.post_auth(new_account)
  end

end