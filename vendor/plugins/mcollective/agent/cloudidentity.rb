module MCollective
  module Agent
    class Cloudidentity<RPC::Agent
      # Basic cloud identity server
      metadata    :name        => "Cloud Identity server",
                        :description => "Actions that expose the cloud identity.",
                        :author      => "Kishorekumar Neelamegam <nkishore@megam.co.in>",
                        :license     => "GPL V3",
                        :version     => "0.1",
                        :url         => "http://megam.co/",
                        :timeout     => 10

      action "listrealms" do
        validate :msg, String

        reply[:msg] = request[:msg]
        reply[:time] = Time.now.to_s
        reply[:status] = run("echo 'I know what you did last summer.'", :stdout => :out, :stderr => :err, :cwd => "/tmp")
      end

      action "showrealm" do
        validate :msg, String
        
        reply[:time] = Time.now.to_s
        reply[:status] = run("echo 'I know what you did last summer.'", :stdout => :out, :stderr => :err, :cwd => "/tmp")
        reply[:msg] = request[:msg]
      end

      action "createrealm" do
        validate :msg, String
        
        reply[:time] = Time.now.to_s
        reply[:status] = run("echo 'I know what you did last summer.'", :stdout => :out, :stderr => :err, :cwd => "/tmp")
        reply[:msg] = request[:msg]
      end

      action "showbrand" do
        validate :msg, String
        
        reply[:time] = Time.now.to_s
        reply[:status] = run("echo 'I know what you did last summer.'", :stdout => :out, :stderr => :err, :cwd => "/tmp")
        reply[:msg] = request[:msg]
      end

      action "createbrand" do
        validate :msg, String
        
        reply[:time] = Time.now.to_s
        reply[:status] = run("echo 'I know what you did last summer.'", :stdout => :out, :stderr => :err, :cwd => "/tmp")
        reply[:msg] = request[:msg]
      end
    end
  end
end