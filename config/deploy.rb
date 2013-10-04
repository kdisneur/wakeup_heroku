require 'bundler/capistrano'
require 'capistrano/ext/multistage'

load 'config/deploy/recipes/base'
load 'config/deploy/recipes/environment_variables'
load 'config/deploy/recipes/logrotate'
load 'config/deploy/recipes/nginx'
load 'config/deploy/recipes/rbenv'
load 'config/deploy/recipes/unicorn'
load 'deploy/assets'

set :application,   'wakeup_heroku'
set :stages,        %w(production)
set_default :user,  'app'

set :scm,          :git
set :repository,   "git@github.com:kdisneur/#{application}.git"
set :use_sudo,     false

ssh_options[:forward_agent] = true
ssh_options[:keys]          = [File.join(ENV['HOME'], '.ssh', 'id_github')]
default_run_options[:pty]   = true

set :keep_releases, 2
after 'deploy:restart', 'deploy:cleanup'
