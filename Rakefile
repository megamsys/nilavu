#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Nilavu::Application.load_tasks

namespace :cache do
  desc "Clears Rails cache"
  task :clear => :environment do
    Rails.cache.clear
  end
end
