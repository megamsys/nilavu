class EmbeddedClient
  
  def initialize
  end

  def client
    client = Stomp::Client.new("hot#1rod", "mcollective", "ironfist.megam.co.in", 6163)
    client.send("/topic/", "hello world!")
    client.subscribe("/topic/") do |msg|
 	  p msg
    end
    client
  end

end

