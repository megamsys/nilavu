desc "Run all specs automatically as needed"
task "autospec" => :environment do
  require 'autospec/manager'

  debug = ARGV.any?{ |a|  a == "d" || a == "debug" } || ENV["DEBUG"]
  force_polling = ARGV.any? { |a| a == "p" || a == "polling" }
  latency = ((ARGV.find { |a| a =~ /l=|latency=/ } || "").split("=")[1] || 3).to_i

  if force_polling
    puts "Polling has been forced (slower) - checking every #{latency} #{"second".pluralize(latency)}"
  else
    puts "If file watching is not working, you can force polling with: bundle exec rake autospec p l=3"
  end

  puts "@@@@@@@@@@@@ Running in debug mode" if debug

  Autospec::Manager.run(force_polling: force_polling, latency: latency, debug: debug)
end
