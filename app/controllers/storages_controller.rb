require 'json'
class StoragesController < ApplicationController

def index
    	buck_list = [
  		        {   "buck_id" => 1 , 
  			"user_id" => 10 ,  
  			"bucket_name" => "A", 
  			"created_at" =>  (Time.now - 1700).strftime('%a %b %d %H:%M') },
  			{   "buck_id" => 2 , 
  			"user_id" => 12 , 
  			"bucket_name" => "B", 
  			"created_at" =>  (Time.now - 1600).strftime('%a %b %d %H:%M') },
  			{   "buck_id" => 3 , 
  			"user_id" => 10 , 
  			"bucket_name" => "C", 
  			"created_at" =>  (Time.now - 1500).strftime('%a %b %d %H:%M') },
  	]
  	@buckets = buck_list.to_json

  end
end

