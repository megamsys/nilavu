require "stomp"
require "singleton"
require "yaml"

#
module Ironfist
  class MsgDoesNotMatchRequestID < RuntimeError; end
    
  class Init
    include Singleton
    
    def initialize
      @ironfist_conf = {}
      configfile = "config/ironfist.cfg"      
      if File.exists?(configfile)
      File.open(configfile, "r") do |line|
        line.read.each_line do |singleline|
          name,value = singleline.chomp.split("=")
          @ironfist_conf[name.to_sym] = value.gsub(" ","")          
        end
      end
      else
        raise("Cannot find config file '#{configfile}'")
      end
    end

    # User id
    def login
      @ironfist_conf[:user] || ENV['STOMP_USER'] || 'user'
    end

    # Password
    def passcode
     @ironfist_conf[:password] || ENV['STOMP_PASSCODE'] || 'passcode'
    end

    # Server host
    def host
      @ironfist_conf[:host] ||ENV['STOMP_HOST'] || "localhost" # The connect host name
    end

    # Server port
    def port
      (@ironfist_conf[:port] ||ENV['STOMP_PORT'] || 61613).to_i # !! The author runs Apollo listening here
    end

    # Required vhost name
    def virt_host
      if @ironfist_conf.include?(:vhost)
        @ironfist_conf[:vhost] || ENV['STOMP_VHOST'] || "/" # The 1.1 virtual host name
      else
        ENV['STOMP_VHOST'] || "/"
      end
    end
    
    # Required vhost name
    def topicname
      @ironfist_conf[:topicname] || ENV['STOMP_TOPIC_NAME'] || "/topic/megamci" # The 1.1 virtual host name
    end
    
    # Required vhost name
    def topicreplyname
      @ironfist_conf[:topicreplyname] || ENV['STOMP_TOPIC_NAME'] || "/topic/megamreplyci" # The 1.1 virtual host name
    end
    
    # Required vhost name
    def timeout
      (@ironfist_conf[:timeout] || ENV['STOMP_TIMEOUT'] || 30).to_i # The 1.1 virtual host name
    end

    # Create a 1.1 commection
    def connection
      conn_hdrs = {"accept-version" => "1.1", # 1.1 only
        "host" => virt_host, # the vhost
      }
      conn_hash = { :hosts => [
          {:login => login, :passcode => passcode, :host => host, :port => port},
        ],
        :connect_headers => conn_hdrs,
      }
      conn = Stomp::Connection.new(conn_hash)
    end
    
    # Create a 1.1 commection
    def client
      conn_hdrs = {"accept-version" => "1.1", # 1.1 only
        "host" => virt_host, # the vhost
      }
      conn_hash = { :hosts => [
          {:login => login, :passcode => passcode, :host => host, :port => port},
        ],
        :connect_headers => conn_hdrs,
      }
      client = Stomp::Client.new(conn_hash)
    end

    # Number of messages
    def nmsgs()
      (ENV['STOMP_NMSGS'] || 1).to_i # Number of messages
    end
    
    def to_s 
       @ironfist_conf.to_yaml
    end
  end
end