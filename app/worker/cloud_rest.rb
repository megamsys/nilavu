class CloudRest

@queue = "test_queue"

puts "Inside Cluod rest"
SANDBOX_HOST_OPTIONS = {
  :host => 'localhost',
  :port => 9000
}


def self.sandbox_apikey
   "IamAtlas{74}NobodyCanSeeME#07"
end

def self.sandbox_email
  "sandy@megamsandbox.com"
end

def self.megams(options={})  
s_options = SANDBOX_HOST_OPTIONS.merge({
  :email => sandbox_email,
  :api_key => sandbox_apikey  
}) 
  options = s_options.merge(options)
  mg=Megam::API.new(options)  
end

puts "test"

def self.hello
	"HELOO"
end

puts hello
#response = megams.post_auth()

sleep 10


end
