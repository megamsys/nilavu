##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class BillingsController < ApplicationController
  respond_to :html, :js

  before_action :stick_keys, only: [:index]
  
  def index
    logger.debug ">----- Billings index."
    logger.debug ">----- #{params}"
    @currencies = ["USD", "IN"]
    bill = Balances.new.show(params)
    puts "000000000000000000000000000000000000"
    puts bill.inspect
    
    billingHistories = Billinghistories.new.list(params)
    puts "000000000000000000000000000000000000"
    puts billingHistories.inspect
    
    
     balance_collection = GetBalance.getBalance(force_api[:email], force_api[:api_key])
      if balance_collection.class == Megam::Error
         logger.info balance_collection.inspect
         redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
      else    
        billinghistories_collection = ListBillingHistories.perform(force_api[:email], force_api[:api_key])
        case billinghistories_collection
        when Megam::Error   
           case 
           when billinghistories_collection.some_msg[:code] == 404
                 @billinghistories = []  
           else 
             redirect_to main_dashboards_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
           end
        else         
             @billinghistories = billinghistories_collection.sort_by{|e| e.created_at}.reverse[0..9]            
        end            
        @bill = balance_collection.lookup(force_api[:email])         
      end  
  end

  def callback_url
    bill = Billings.new
    res = bill.execute(params)
    if res == Megam::Error
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "PayPal transaction got error. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
    else 
      if bill.updatebalance(res, force_api[:email], force_api[:api_key]) == Megam::Error
         redirect_to main_dashboards_path, :gflash => { :warning => { :value => "Balance updation got error. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
       else 
         redirect_to billings_path
      end      
    end     
  end

  def create    
    res = Billings.new.create(params)
    if res.class == Megam::Error
       respond_to do |format|
          format.html {redirect_to billings_path}
          format.js {render :js => "window.location.href='"+billings_path+"'"}
       end       
    else 
       respond_to do |format|
          format.html {redirect_to res}
          format.js {render :js => "window.location.href='"+res+"'"}
       end 
    end
  end

end