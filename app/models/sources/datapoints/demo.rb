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
    class Demo < Sources::Datapoints::Base

      def get(options = {})
        from    = (options[:from]).to_i
        to      = (options[:to] || Time.now).to_i
        result_json = {}

        host = "portability.megambox.com"
       uptime = Random.rand(10...100)
       os =  Random.rand(10...100)
       cpus = Random.rand(10...100)
        model_rpm = Random.rand(10...100)
        new_books = Random.rand(10...100)
        total_books = Random.rand(10...100)
        result1 = {}
        result1 = { 'uptime' => uptime, 'os' => os, 'cpus' => cpus, 'host' => host }

        target_hash = { 'cpu' => %w(cpu_idle cpu_user cpu_system), 'disk' => %w(disk_total disk_free), 'memory' => %w(mem_free mem_cached), 'network' => %w(bytes_out bytes_in) }
        target_hash.each do |target_key, target_value|
          targets = target_value
          ganglia_datapoints = request_datapoints_dash(from, to, targets)

          result = []
          targets.each_with_index do |target, index|
            result << { 'target' => target, 'datapoints' => ganglia_datapoints[index] }
          end
          result1["#{target_key}"] = result
        end # Each target_hash
        fail Sources::Datapoints::NotFoundError if result1.empty?
        result1
      end

      def request_datapoints_dash(from, to, targets)
        result = []
        targets.each do |_target|
          response = ::DemoHelper.generate_datapoints(from, to)
          if response == 'null'
            result << []
          else
            result << response
          end
        end
        result
       end

      def getHost(widget_id)
        widget  = Widget.find(widget_id.to_i)
        dashboard_id = widget.dashboard_id
        # dashboard = Dashboard.find(dashboard_id)
        dashboard = App.find(dashboard_id)
        dashboard.name
      end
    end
  end
end
