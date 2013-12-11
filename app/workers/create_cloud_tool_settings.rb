class CreateCloudToolSettings
  puts " -------> CREATE CloudToolSettings "
  def self.perform(new_cts)
    puts "=============================> CREATE CLOUDTOOLSETTINGS PERFORM PARAMS <================================== "
    puts new_cts
    begin
      Megam::Config[:email] = new_cts[:email]
      Megam::Config[:api_key] = new_cts[:api_key]
      @excon_res = Megam::CloudToolSetting.create(new_cts)
      puts "=========================> @excon_res in CREATE CLOUDTOOLSETTINGS <====================="
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
