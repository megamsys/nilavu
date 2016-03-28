# If Mini Profiler is included via gem
if Rails.configuration.respond_to?(:load_mini_profiler) && Rails.configuration.load_mini_profiler
  require 'rack-mini-profiler'
  require 'flamegraph'

  begin
    require 'memory_profiler' if RUBY_VERSION >= "2.1.0"
  rescue => e
     STDERR.put "#{e} failed to require mini profiler"
  end

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end

if defined?(Rack::MiniProfiler)

  skip = [
     /assets/,
    /qunit/,
    /srv\/status/,
    /^\/logs/,
    /^\/site_customizations/,
    /^\/uploads/,
    /^\/javascripts\//,
    /^\/images\//,
    /^\/stylesheets\//,
    /^\/favicon\/proxied/
  ]

  # For our app, let's just show mini profiler always, polling is chatty so nuke that
  Rack::MiniProfiler.config.pre_authorize_cb = lambda do |env|
    path = env['PATH_INFO']

    (env['HTTP_USER_AGENT'] !~ /iPad|iPhone|Nexus 7|Android/) &&
    !skip.any?{|re| re =~ path}
  end

  # without a user provider our results will use the ip address for namespacing
  #  with a load balancer in front this becomes really bad as some results can
  #  be stored associated with ip1 as the user and retrieved using ip2 causing 404s
  Rack::MiniProfiler.config.user_provider = lambda do |env|
    request = Rack::Request.new(env)
    id = request.cookies["_t"] || request.ip || "unknown"
    id = id.to_s
    # some security, lets not have these tokens floating about
    Digest::MD5.hexdigest(id)
  end

  Rack::MiniProfiler.config.position = 'left'
  Rack::MiniProfiler.config.backtrace_ignores ||= []
  Rack::MiniProfiler.config.backtrace_ignores << /config\/initializers\/silence_logger/
  Rack::MiniProfiler.config.backtrace_ignores << /config\/initializers\/quiet_logger/
end


if ENV["PRINT_EXCEPTIONS"]
  trace      = TracePoint.new(:raise) do |tp|
    puts tp.raised_exception
    puts tp.raised_exception.backtrace.join("\n")
    puts
  end
  trace.enable
end
