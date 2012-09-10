class EmbeddedClient
  
  def initialize
  end

  def client
    client = Stomp::Client.new("mcollective","hot#1rod", "ironfist.megam.co.in", 6163)
    client.publish("/topic/", "hello world!")
    client.subscribe("/topic/") do |msg|
 	  p msg
    end
    client
  end

end

