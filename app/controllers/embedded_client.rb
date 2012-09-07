require 'mcollective'

class EmbeddedClient
  include MCollective::RPC
  def initialize
    @logger = Logger.new(STDOUT)
  end

  def client
    log_stderr do
      options =  MCollective::Util.default_options
      options[:config] = 'config/mcollective.cfg'
      @logger.debug "starting up mcollective."
      client = MCollective::RPC::Client.new("cloudidentity", :options => options)
      client.discovery_timeout = 10
      client.timeout = 60
      @logger.debug "listing realms"
      client.listrealms(:msg => "Howdy megam").each do |resp|
        printf("%-40s: %s\n", resp[:sender], resp[:data][:msg])
      end
      @logger.debug "listed realms, disconnecting.."
      client.disconnect
    end
  end

  def log_stderr &block
    begin
      real_stderr, $stderr = $stderr, StringIO.new
      yield
    ensure
      $stderr, stderr = real_stderr, $stderr
      stderr.string.each_line do |line|
        log(:error, "stderr: #{line}")
        @logger.debug("stderr: #{line}")
      end
    end
  end

end

