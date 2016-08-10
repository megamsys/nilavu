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
          #{error: I18n.t('errors.desc.not_found')}
          {:error => "Oops, the application tried to load a URL that doesn't exist."}
      end
    end

    def after_subscribe(subscribed)
        result = Biller::Result.new
    end

    def update(update_options)
        WHMCS::Client.update_client(update_options)
    end

    def after_update(updated)
        result = Billy::Result.new      
    end
end
