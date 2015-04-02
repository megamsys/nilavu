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
module Meat
  class Addons

    attr_accessor :node_id, :node_name, :marketplace_id, :locations, :fromhost, :tohosts,  :haproxyhost, :loadbalancehost,
    :cputhreshhold, :memorythreshhold, :noofinstances, :agent, :backuphost
    def initialize(fparams = {})
      @node_id = fparams[:node_id] || nil
      @node_name = fparams[:node_name] || nil
      @marketplace_id = fparams[:marketplace_id] || nil
      @locations = fparams[:locations] || nil
      @fromhost = fparams[:fromhost] || nil

      if (fparams[:backuphost] != "Choose an App/Service" && fparams[:backuphost].to_s.strip.length != 0 ) 
      	@backuphost = fparams[:backuphost]
      else
      	@backuphost = ""
      end
      @tohosts = fparams[:tohosts] || nil
      @haproxyhost = fparams[:haproxyhost] || nil
      @loadbalancehost = fparams[:loadbalancehost] || nil
      @cputhreshhold = fparams[:cputhreshhold] || nil
      @memorythreshhold = fparams[:memorythreshhold] || nil
      @noofinstances = fparams[:noofinstances] || nil
      @agent = fparams[:agent] || nil     
    end

    def meatball(validate=false)
      addons_hash = {}
      if validate
        raise "You must specify a node id" % @node_id unless @node_id
        raise "You must specify a node name" % @node_name unless @node_name
        raise "You must specify a marketplace id" % @marketplace_id unless @marketplace_id
      end

      tmp_tohosts = @tohosts.join(",")  if !@tohosts.nil?
      tmp_tohosts || @tohosts
      if @backuphost.to_s.strip.length == 0
      		role = "role[drbd]"
      else
      		role = "role[backup]"
      end
      	
      addon_config = {
        "disaster"=> {
          "locations"=> @locations,
          "fromhost"=> @fromhost,
          "tohosts"=> tmp_tohosts,
          "recipe" => role
        },
        "loadbalancing"=>{
          "haproxyhost"=>@haproxyhost,
          "loadbalancehost"=>@loadbalancehost,
          "recipe" => "role[haproxy]"
        },
        "autoscaling"=>{
          "cputhreshold"=>@cputhreshhold,
          "memorythreshold"=>@memorythreshhold,
          "noofinstances"=>@noofinstances,
          "recipe" => "role[autoscaling]"
        },
        "monitoring"=>{
          "agent"=>@agent,
          "recipe" => "role[op5agent]"
        }
      }

      addons_hash = {
        "node_id" => @node_id,
        "node_name" => @node_name,
        "marketplace_id" => @marketplace_id,
        "config" => addon_config
      }

    end

    def meatball_h
      {  :node_id => @node_id,
        :node_name => @node_name,
        :marketplace_id => @marketplace_id
      }
    end
  end
end

