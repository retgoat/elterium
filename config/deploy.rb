# config valid for current version and patch releases of Capistrano
require "rvm/capistrano"
# require "bundler/capistrano"

lock "~> 3.11.0"

server 'easyquote.pw', user: 'deployer', roles: %w{web app}, port: 22123

set :application,   "elterium"
set :repo_url,      "git@github.com:retgoat/elterium.git"
set :user,          "deployer"
set :keep_releases, 10
set :format,        :pretty
set :log_level,     :debug
set :ssh_options,   { forward_agent: true }
set :branch,        ENV['BRANCH'] || :master
set :keep_releases, 5

set :rvm_type, :user
set :rvm_ruby_version, '2.6.3' # use the same ruby as used locally for deployment

set :deploy_to, "/home/deployer/web_apps/elterium.com"

set :linked_files, %w{puma.rb .env}
set :linked_dirs,  %w{log tmp}


set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil



# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
