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


class Billings < BaseFascade
  
  def initialize()
    
  end
  
  def create(params) 
    res = case 
    when params["commit"] == "Pay with Paypal"
      Paypal.generate_url(params)
    when params["commit"] == "Pay with Coinkite"
      Coinkite.generate_url(params)
    end  
    res
  end
  
  def execute(params)
    res = case
    when params["PayerID"]
      Paypal.execute(params)
    end
    res
  end
  
  def updatebalance(amount, email, api_key)
     balance_collection = GetBalance.getBalance(email, api_key)
      case
      when balance_collection.class == Megam::Error         
         return balance_collection
      else
        balance = balance_collection.lookup(email)       
         options = { :id => balance.id, :accounts_id => balance.accounts_id, :name => balance.name, :credit => balance.credit.to_i + amount.to_i, :created_at => balance.created_at, :updated_at => balance.updated_at }
         res_body = UpdateBalance.perform(options, email, api_key)
         case
         when res_body.class == Megam::Error
           return res_body
         else
            credithistory_options = { :bill_type => "paypal", :credit_amount => amount, :currency_type => "USD"}
            credit_res = CreateCreditHistory.perform(credithistory_options, email, api_key)
            return credit_res
         end
      end        
  end 
 
  
end