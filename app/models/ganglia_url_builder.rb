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
class GangliaUrlBuilder

  def initialize(base_url)
    @base_url = Ind.http_metrics
  end

  def datapoints_url(range, target, host)
    cluster, metric = parse_target(target)
    url = "#{@base_url}/graph.php"
    params = { :c => cluster, :h => host, :json => 1, :m => metric }
    { :url => url, :params => params.merge(custom_range_params(range)) }
  end

  def metrics_url(query)
    "#{@base_url}/search.php?q=#{query}"
  end

  def data_url(range, target, host)
    cluster, metric = parse_target(target)
    url = "#{@base_url}/host_overview.php"
    params = { :c => cluster, :h => host, :json => 1, :m => metric }
    { :url => url, :params => params.merge(custom_range_params(range)) }
  end

  def parse_target(target)
    #target =~ /(.*)@(.*)\((.*)\)/
    #host = 'ip-10-142-85-146.ap-southeast-1.compute.internal'
    #host = 'gmond'
    cluster = Ind.stream_metrics_cluster
    metric  = target
        [cluster, metric]
  end

  def custom_range_params(range)
     #{ :r => "hour", :cs => '09/12/2013 06:40', :ce => '09/12/2013 07:00' }
     { :r => range, :cs => '', :ce => '' }
    #{ :r => "custom", :cs => format(from), :ce => format(to) }
  end

  def format(timestamp)
    time = Time.at(timestamp)
    time.strftime("%m/%d/%Y %H:%M")
  end

end
