# we need to move to Rails 4.0 Queues, when it comes. (or) migrate to 4.0 version.
require "resque/tasks"

task "resque:setup" => :environment