##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http=>//www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
module Sources
  module Containers
    class Cadvisor < Sources::Containers::Base
      def get(options = {})

      url = URI.parse('http://192.168.1.100:8080/api/v1.3/docker/159ed9b61d28abe86efd043384a5e556cbe2a0d4314c1d6336fa652ce5506429')
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
      json = JSON.parse(res.body)
      json["/docker/159ed9b61d28abe86efd043384a5e556cbe2a0d4314c1d6336fa652ce5506429"]
      end

    end
  end
end