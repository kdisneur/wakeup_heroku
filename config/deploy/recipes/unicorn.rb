set_default(:unicorn_user)   { user }
set_default(:unicorn_pid)    { File.join(shared_path, 'pids', 'unicorn.pid') }
set_default(:unicorn_config) { File.join(shared_path, 'config', 'unicorn.rb') }
set_default(:unicorn_workers, 2)
set_default(:shared_bundler_gems_path) { File.join(shared_path, 'bundle', 'ruby', ruby_base_version) }

namespace :unicorn do
  desc 'Setup Unicorn initializer and app configuration'
  task :setup, roles: :web do
    run "mkdir -p #{shared_path}/config"
    template('unicorn.rb.erb', unicorn_config)
    template('unicorn_init.erb', '/tmp/unicorn_init')
    run 'chmod +x /tmp/unicorn_init'
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}_#{stage}"
    run "#{sudo} update-rc.d -f unicorn_#{application}_#{stage} defaults"
  end
  after 'deploy:setup', 'unicorn:setup'

  %w(start stop restart).each do |command|
    desc "#{command} unicorn"
    task command, roles: :web do
      run "service unicorn_#{application}_#{stage} #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end
