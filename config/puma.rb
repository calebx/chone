#!/usr/bin/env puma

environment 'production'
daemonize true

application_path = '/home/ruby/apps/jining/current'
directory application_path

pidfile "#{application_path}/tmp/pids/puma.pid"
stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"

preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

# RAILS_ENV=production bundle exec puma -C ./config/puma.rb
