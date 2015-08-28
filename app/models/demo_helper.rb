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
module DemoHelper
  extend self
  
  def generate_datapoints(from, to)
    range = to - from
    interval = case range
    when 60*30 then 10
    when 60*60 then 10
    when 3600*3 then 10*3
    when 3600*6 then 10*6
    when 3600*12 then 10*12
    when 3600*24 then 10*24
    when 3600*24*3 then 10*12*3
    when 3600*24*7 then 10*12*7
    when 3600*24*7*4 then 10*12*7*4
    else 10 end
    
    result = []
    result0 = []
    timestamp = from
    while (timestamp < to) 
      result0 << [Random.rand(1...7), timestamp]    
      timestamp = timestamp + interval*5 #* (1+rand(5))
    end    
    result0
  end
  
  def get_rand_data(from, to)
     Random.rand(10...100) 
  end
end