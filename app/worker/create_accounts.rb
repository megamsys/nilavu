class CreateAccounts

  @queue = "accounts"
  
  #this returns a Megam::Account object
  #error? allows to check for an error.
  def self.perform(new_account={})
    Megam::Config[:email] = new_account[:email]
    Megam::Config[:api_key] = new_account[:api_key]
    Megam::Account.create(new_account)
  end

end