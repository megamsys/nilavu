require 'whmcs'

class Biller::WHMCSSubscriber < Biller::Subscriber
    include Biller::WHMCSRegistrar

    def initialize
      register
    end

    def subscribe(subscribe_options={})
      begin
        WHMCS::Client.get_clients_details(subscribe_options)
      rescue StandardError => se
          {:result => "error", :error => "errors.desc.not_found"}
      end
    end


    def after_subscribe(subscribed)
        result = Biller::Result.new
        subscribed.attributes.each { |k, v| result.send("#{k}=", v) }
        result.to_hash
    end

    def update(update_options)
      begin
        WHMCS::Client.update_client(update_options)
      rescue StandardError => se
          {:result => "error", :error => "errors.desc.not_found"}
      end
    end

    def after_update(updated)      
        result = Biller::Result.new
        updated.attributes.each { |k, v| result.send("#{k}=", v) }
        result.to_hash
    end
end
