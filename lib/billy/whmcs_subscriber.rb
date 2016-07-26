require 'whmcs'
require 'digest/md5'

class Billy::WHMCSSubscriber < Billy::Subscriber
    include WHMCSRegistrar

    def subscribe(subscribe_options)
        WHMCS::Client.get_clients_details(subscribe_options)
    end

    def after_subscribe(user, subscribed)
        result = Billy::Result.new
        puts "----------- subscribed "
        puts subscribed.inspect
        puts "----------- subscribed..."
    end

    #:clientid, :clientemail
    def update(update_options)
        WHMCS::Client.update_client(update_options)
    end

    def after_update(user, updated)
        result = Billy::Result.new
        puts "----------- update"
        puts updated.inspect
        puts "----------- updated..."
    end
end
