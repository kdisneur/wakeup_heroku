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
set_default :user,          'app'

set :scm,          :git
set :repository,   "git@github.com:kdisneur/#{application}.git"
set :use_sudo,     false

set :ruby_version, '2.0.0-p247'
set :server_os,    'ubuntu-12-04'

ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV['HOME'], '.ssh', 'id_github')]

set :keep_releases, 2
after 'deploy:restart', 'deploy:cleanup'
