class CreateAccounts
  puts " -------> CREATE ACCOUNTS "
  @queue = "demo1"

  def self.perform(new_account)
puts "TEST 1--> "
    new_account = new_account.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
puts "TEST 2--> "
    #sleep 3
    puts "Doing something complex with #{new_account}"
    puts "Doing something complex with #{new_account[:email]}"
    Megam::Config[:email] = new_account[:email]
    Megam::Config[:api_key] = new_account[:api_key]
    Megam::Account.create(new_account)
  end

end
