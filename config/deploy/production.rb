server 'wakeupheroku.koboyz.org', :web, :app, :db, :resque_worker, :resque_scheduler, primary: true

set :rails_env, :production
set :app_env,   rails_env
set :deploy_to, "/home/#{user}/apps/#{application}_#{stage}"
set :host_name, 'wakeupheroku.koboyz.org'

set :branch,    'master'
