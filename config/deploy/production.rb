server 'wakeupheroku.shokunin.io', :web, :app, :db, :resque_worker, :resque_scheduler, primary: true

set :rails_env, :production
set :app_env,   rails_env
set :deploy_to, "/home/#{user}/#{application}"
set :host_name, 'wakeupheroku.shokunin.io'

set :branch,    'master'
