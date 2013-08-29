class CreateAccounts
  puts " -------> CREATE ACCOUNTS "
  def self.perform(new_account)
    #new_account = new_account.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    #sleep 3
    puts "=============================> CREATE ACCOUNT PERFORM PARAMS <================================== "
    puts new_account
    begin
      Megam::Config[:email] = new_account[:email]
      Megam::Config[:api_key] = new_account[:api_key]
      @excon_res = Megam::Account.create(new_account)
      puts "=========================> @excon_res in CREATE ACCOUNTS <====================="
      puts @excon_res.inspect
    rescue ArgumentError => ae
      puts "===========================> AE <======================================="
      hash = {"msg" => ae.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      puts "===========================> EWR <======================================="
      hash = {"msg" => ewr.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue StandardError => se
      puts "===========================> SE <======================================="
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    end
    @excon_res.data[:body]
  end
end
