server '37.139.24.194', :web, :app, :db, :resque_worker, :resque_scheduler, primary: true
# server 'www.wakeupheroku.org', :web, :app, :db, :resque_worker, :resque_scheduler, primary: true

set :rails_env, :production
set :app_env,   rails_env
set :deploy_to, "/home/#{user}/apps/#{application}_#{stage}"
set :host_name, '37.139.24.194'
#set :host_name, 'www.wakeupheroku.org'
set :branch,    'master'
