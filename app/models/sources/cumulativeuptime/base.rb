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
  module Cumulativeuptime

    class Error < StandardError; end
    class NotFoundError < Error; end

    class Base

      def available?
        true
      end

      def supports_target_browsing?
        false
      end

      def supports_functions?
        false
      end

      def custom_fields
        []
      end

      def default_fields
        [
          { name: "targets", title: "Targets", mandatory: true }
        ]
      end

      def get(options = {})
      end

      protected

      def targetsArray(targets)
        targets.split(";").map { |t| t.strip }
      end

      @@cache = {}

      def cached_get(key)
        return yield if Rails.env.test?

        time = Time.now.to_i
        if entry = @@cache[key]
          if entry[:time] > 5.minutes.ago.to_i
            Rails.logger.info("Sources::Datapoints - CACHE HIT for #{key}")
            return entry[:value]
          end
        end

        value = yield
        @@cache[key] = { :time => time, :value => value }
        value
      end
    end
  end
end