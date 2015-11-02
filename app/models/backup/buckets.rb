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
module Backup
  class Buckets < BackupService
    attr_reader :saved_size

    def initialize(params)
      super(params)
      @saved_size = 0
    end

    def create(name)
      @cephs3.buckets.build(name).save
    end

    def delete(name)
      buckets.find("#{name}").destroy
    end

    def list
      result ||= buckets.map do |abucket|
        { name: "#{abucket.name}", size: size(abucket).to_s(:human_size),
        count: count(abucket)}
      end
        { total_buckets: buckets.count, buckets: result||{}, total_size: total}
      end

      private
      def size(abucket)
        size ||= abucket.objects.inject { |n, bobject| n + boject.size.to_i }
        @saved_size ||= size
      end

      def count(abucket)
        abucket.objects.count
      end

      def total
        @saved_size ||= @saved_size.reduce(:+)
      end
    end
  end
