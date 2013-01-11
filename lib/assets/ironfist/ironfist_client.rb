require 'stomp'
require 'ironfist_common'

class IronfistClient
  include Ironfist
  def initialize
    #@ironinit = Ironfist::Init.instance
  end

  def client
    stompclient = @ironinit.client
  end

  def connection
    stompconn = @ironinit.connection
    puts @ironinit.to_s
  end

  # the parameter format is
  # AGENT=IRONCRAB COMMAND=CREATEREALM following by parms : PARAM1=value1 PARAM2=value2
  def create_parms (reqid, agent, command, message)
    {:senderid => 'megam.co',
      :requestid => reqid,
      :senderagent => agent,
      :command => command,
      :msgtime => Time.now.to_i,
      :message => message}

  end
  
  # the parameter format is
  # AGENT=IRONCRAB COMMAND=CREATEREALM MESSAGE=msg MSGTIME=time REQ
  def create_out (msg)
    @ironout = Ironfist::Output.new(msg)
  end
  
  def fake
	puts "federate - before sleep"
	sleep 10
	puts "federate - after sleep"

  end

  def pub_and_wait(conn,ironfistparms, waitfor=0)
    stat = {:starttime => Time.now.to_f, :blocktime => 0, :totaltime => 0}

    hosts_responded = 0
    begin
      Timeout.timeout(@ironinit.timeout) do

        reqid = publish(conn, ironfistparms[:agent], ironfistparms[:command],ironfistparms[:message])

        loop do
          resp = receive(conn,reqid)

          hosts_responded += 1

          yield(resp)

          break if (waitfor != 0 && hosts_responded >= waitfor)
        end
      end
    rescue Interrupt => e
    rescue Timeout::Error => e
    end

    stat[:totaltime] = Time.now.to_f - stat[:starttime]
    stat[:responses] = hosts_responded
    stat[:noresponsefrom] = []

    @stats = stat
    return stat

  end

  def receive(conn,requestid = nil)
    msg = Hash.new
    tmsg = nil

    begin
      tmsg = conn.receive
      out = Ironfist::Output.new(tmsg)
      msg= out.to_hash
     raise(MsgDoesNotMatchRequestID, "Message reqid #{requestid} does not match our reqid #{msg[:requestid]}") if msg[:requestid] != requestid
      
    rescue MsgDoesNotMatchRequestID => e
    retry
    end
    msg
  end

  private

  def publish(conn, agent,command,message)
    reqid = Digest::MD5.hexdigest("#{agent}-#{Time.now.to_f.to_s}-#{command}")
    req = create_parms(reqid, agent,command,message)

    conn.subscribe(@ironinit.topicreplyname,headers = {}, req)
    puts "subscribed to #{@ironinit.topicreplyname}"
    Timeout.timeout(2) do
      conn.publish(@ironinit.topicname,headers = {}, req)
       puts "published to #{@ironinit.topicname}" + req.to_yaml

    end

    return reqid

  end

end

