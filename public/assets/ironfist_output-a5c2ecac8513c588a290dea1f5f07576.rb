require "yaml"

module Ironfist
  class Output
    def initialize (msg)
      @out = msg
      @senderid =""
      @agent =""
      @command=""
      @msgtime=""
      @message=""
    end

    def output      
      puts @out
      if @out
         @out.split(/\s/).each do |singleval| # split on space
               if (singleval =~ /(.+?)\s*=\s*(.+)/) #split on equals
                   key = $1.downcase
                   val = $2
                   case key
                       when "senderid"
                         @senderid = val
                       when "requestid"
                          @reqid = val
                       when "agent"
                          @agent = val
                       when "command"
                          @command = val
                       when "msgtime"
                          @msgtime = val
                       when "message"
                          @message = val
                       else 
                       raise("Unknown output #{key}")
                 end
               end                
       end 
    end     
    
    {:senderid => @senderid,
      :requestid => @reqid,
      :agent => @agent,
      :command => @command,
      :msgtime => @msgtime,
      :message => @message}
     end
     
     def to_hash
       output
     end
  end
end



outp = Ironfist::Output.new("AGENT=Cloud COMMAND=listrealm MESSAGE=TESTE SENDERID=cinode REQUESTID=000001 MSGTIME=00001") 
puts outp.output.to_yaml