require 'mcollective'

class EmbeddedClient
	include MCollective::RPC
  def client
   options =  MCollective::Util.default_options
    options[:config] = 'config/mcollective.cfg'
	#logger.debug "#{agent}"
    MCollective::RPC::Client.new("cloudidentity", :options => options)
    #client = rpcclient("cloudidentity", {:options => options})
    client.discovery_timeout = 30
    client.timeout = 60
   client.listrealms(:msg => "Howdy megam") .each do |resp|
   printf("%-40s: %s\n", resp[:sender], resp[:data][:msg])
end
    client.close 
 end


  
end

