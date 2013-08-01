class CreateAccounts
  
  @queue = "accounts" 
  
 #we can pull it up from development.yml


  def self.perform(new_account)
    new_account = new_account.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    Megam::Config[:email] = new_account[:email]
    Megam::Config[:api_key] = new_account[:api_key]
    Megam::Account.create(new_account)
  end

end
