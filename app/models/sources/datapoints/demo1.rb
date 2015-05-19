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
module Sources
  module Datapoints
    class Demo1 < Sources::Datapoints::Base
       def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i

        graph_datas = []
          graph_datas << {:datapoints => ::DemoHelper.generate_datapoints(from, to), :uptime_data => ::DemoHelper.get_rand_data(from, to), :rpm => ::DemoHelper.get_rand_data(from, to) }
        graph_datas
      end


    end
  end
end
