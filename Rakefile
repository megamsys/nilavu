#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Nilavu::Application.load_tasks

desc 'run static analysis with rubocop'
task(:rubocop) do
  require 'rubocop'
  cli = RuboCop::CLI.new
  exit_code = cli.run(%w(--display-cop-names --format simple))
  raise "RuboCop detected offenses" if exit_code != 0
end

desc "verify that commit messages match CONTRIBUTING.md requirements"
task(:commits) do
  # This git command looks at the summary from every commit from this branch not in master.
  # Ideally this would compare against the branch that a PR is submitted against, but I don't
  # know how to get that information. Absent that, comparing with master should work in most cases.
  %x{git log --no-merges --pretty=%s master..$HEAD}.each_line do |commit_summary|
    # This regex tests for the currently supported commit summary tokens: maint, doc, packaging, or pup-<number>.
    # The exception tries to explain it in more full.
    put "#{commit_summary}"
    if /^\((maint|doc|docs|packaging|pup-\d+)\)|revert/i.match(commit_summary).nil?
      raise "\n\n\n\tThis commit summary didn't match CONTRIBUTING.md guidelines:\n" \
        "\n\t\t#{commit_summary}\n" \
        "\tThe commit summary (i.e. the first line of the commit message) should start with one of:\n"  \
        "\t\t(docs)\n" \
        "\t\t(maint)\n" \
        "\t\t(packaging)\n" \
        "\n\tThis test for the commit summary is case-insensitive.\n\n\n"
    end
  end
end
