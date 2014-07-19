require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

# Basic settings:
set :domain,     '121.197.3.147'
set :user,       'ruby'
set :deploy_to,  '/home/ruby/apps/calebx/chone_prod'
set :repository, 'https://github.com/calebx/chone.git'
set :branch,     'master'
set :stage,      'production'
set :shared_paths, ['config/database.yml', 'log', 'tmp']

# FIX: password input
set :term_mode, :system

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
  
  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    # invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke 'puma:start'
    end
  end
end

desc "Shows logs."
task :logs do
  queue %[cd #{deploy_to!} && tail -f shared/log/production.log]
end

namespace :puma do
  desc "Start the application"
  task :start do
    queue 'echo "-----> Start Puma"'
    queue "cd #{deploy_to}/current && bundle exec puma -q -d -C config/puma.rb"
  end

  desc "Stop the application"
  task :stop do
    queue 'echo "-----> Stop Puma"'
    queue "cd #{deploy_to}/current && bundle exec pumactl -P tmp/pids/puma.pid  stop"
  end

  desc "Restart the application"
  task :restart do
    queue 'echo "-----> Restart Puma"'
    queue "cd #{deploy_to}/current && bundle exec pumactl -P tmp/pids/puma.pid restart"
  end
end
