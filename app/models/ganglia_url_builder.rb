class GangliaUrlBuilder

  def initialize(base_url)
    @base_url = Rails.configuration.ganglia_base_url   
  end

  def datapoints_url(from, to, target)
    puts "datapoints_url"
    cluster, host, metric = parse_target(target)
    url = "#{@base_url}/graph.php"    
    params = { :c => cluster, :h => host, :json => 1, :m => metric }
    { :url => url, :params => params.merge(custom_range_params(from, to)) }
  end

  def metrics_url(query)
    "#{@base_url}/search.php?q=#{query}"
  end

  def data_url(from, to, target)
    puts "datapoints_url"
    cluster, host, metric = parse_target(target)
    url = "#{@base_url}/host_overview.php"    
    params = { :c => cluster, :h => host, :json => 1, :m => metric }
    { :url => url, :params => params.merge(custom_range_params(from, to)) }
  end

  def parse_target(target)
    #target =~ /(.*)@(.*)\((.*)\)/    
    #host = 'ip-10-142-85-146.ap-southeast-1.compute.internal'
    host = 'gmond'
    cluster = Rails.configuration.ganglia_cluster
    metric  = target
        [cluster, host, metric]
  end

  def custom_range_params(from, to)
     #{ :r => "hour", :cs => '09/12/2013 06:40', :ce => '09/12/2013 07:00' }
     { :r => "hour", :cs => '', :ce => '' }
    #{ :r => "custom", :cs => format(from), :ce => format(to) }
  end

  def format(timestamp)
    time = Time.at(timestamp)
    time.strftime("%m/%d/%Y %H:%M")
  end

end