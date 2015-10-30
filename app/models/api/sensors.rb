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
module Api
  class Sensors < APIDispatch
    attr_reader :sensors

    def initialize
      @sensors = []
    end

    def list(api_params, &_block)
      raw = api_request(api_params, SENSORS, LIST)
      @sensors = to_hash(raw[:body])
      yield self if block_given?
      self
    end

    def to_hash(sensors_collection)
      sensors = []
      sensors_collection.each do |sensor|
        sensors << { sensor_type: sensor.sensor_type, payload: sensor.payload, created_at: sensor.created_at.to_time.to_formatted_s(:rfc822) }
      end
      sensors.sort_by { |vn| vn[:created_at] }
    end
  end
end
