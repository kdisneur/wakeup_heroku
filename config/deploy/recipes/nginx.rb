namespace :nginx do
  desc 'Install latest stable release of nginx'
  task :install, roles: :web do
    run "#{sudo} aptitude -y update"
    run "#{sudo} aptitude -y install nginx"
  end
  after 'deploy:install', 'nginx:install'

  desc 'Setup nginx configuration for this application'
  task :setup, roles: :web do
    filename = "#{application}_#{stage}"
    template 'nginx_unicorn.conf.erb', "/tmp/#{filename}_nginx.conf"
    template 'nginx_proxy.conf.erb',   '/tmp/proxy.conf'
    run "#{sudo} mv /tmp/#{filename}_nginx.conf /etc/nginx/sites-available/#{filename}.conf"
    run "#{sudo} mv /tmp/proxy.conf /etc/nginx/conf.d/proxy.conf"
    run "#{sudo} ln -fs /etc/nginx/sites-available/#{filename}.conf /etc/nginx/sites-enabled/#{filename}.conf"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after 'deploy:setup', 'nginx:setup'

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end
