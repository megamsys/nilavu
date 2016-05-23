class VirtualMachinesScrubber < Scrubber

    TORPEDO             =  'TORPEDO'.freeze

    CATTYPES            =  [TORPEDO]

    def name
        "virtualmachines"
    end


    def scrubbed
        convert_launchable_items
    end

    def after_scrubbed
        data.map{|l| l.to_h}
    end

    def register_honeypot(data)
        @data =  data
    end

    protected

    def convert_launchable_items
        CATTYPES.each  do |cattype|
            @data[cattype].map { |m| LaunchableItem.new(m)}
        end
    end
end
