require 'whmcs'

class Biller::WHMCSOnboarder < Biller::Onboarder
    include Biller::WHMCSRegistrar

    def initialize
      register
    end

    def onboard(onboard_options={})
      begin
        WHMCS::Client.add_client(onboard_options).attributes
      rescue StandardError => se
          {:result => "error", :error => "errors.desc.not_found"}
      end
    end


    def after_onboard(onboarded)

        result = Biller::Result.new
        onboarded.each { |k, v| result.send("#{k}=", v) }
        result.to_hash
    end
end
