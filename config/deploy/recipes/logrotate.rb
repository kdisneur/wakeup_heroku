set_default(:rails_log_path) { File.join(shared_path, 'log', '*.log') }
set_default(:logrotated_path, '/etc/logrotate.d')
set_default(:logrotated_filename, 'rails')
set_default(:logrotate_bin, '/usr/sbin/logrotate')

set_default(:logrotate_days, '7')

namespace :logrotate do
  desc 'Generate and install the rails logrotate configuration file.'
  task :setup, roles: :app do
    template('logrotate.conf.erb', '/tmp/rails_logrotate')
    run "#{sudo} mv /tmp/rails_logrotate #{logrotated_path}/#{logrotated_filename}"
    run "#{sudo} chown root:root #{logrotated_path}/#{logrotated_filename}"
  end
  after 'deploy:setup', 'logrotate:setup'

  desc 'Force the rotation of the rails logs.'
  task :force, roles: :app do
    run "#{sudo} #{logrotate_bin} -f #{logrotated_path}/#{logrotated_filename}"
  end
end
