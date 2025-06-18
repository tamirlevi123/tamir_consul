#!/usr/bin/env puma

rails_root = File.expand_path("../../..", __FILE__)

# Load environment variables from .env file
env_file = File.join(rails_root, '.env')
if File.exist?(env_file)
  File.readlines(env_file).each do |line|
    key, value = line.strip.split('=', 2)
    ENV[key] = value if key && value
  end
end

directory rails_root
rackup "#{rails_root}/config.ru"

tag ""

# Ensure directories exist
require 'fileutils'
FileUtils.mkdir_p("#{rails_root}/tmp/pids")
FileUtils.mkdir_p("#{rails_root}/tmp/sockets")
FileUtils.mkdir_p("#{rails_root}/log")

pidfile "#{rails_root}/tmp/pids/puma.pid"
state_path "#{rails_root}/tmp/pids/puma.state"
stdout_redirect "#{rails_root}/log/puma_access.log", "#{rails_root}/log/puma_error.log", true

# Use TCP binding for testing environment
bind "tcp://0.0.0.0:3005"

threads 0, 16
workers 2
preload_app!

restart_command "bundle exec --keep-file-descriptors puma"
plugin :tmp_restart

on_restart do
  puts "Refreshing Gemfile"
  ENV["BUNDLE_GEMFILE"] = ""
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end 