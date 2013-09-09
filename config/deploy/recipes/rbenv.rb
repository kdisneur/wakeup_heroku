set_default :ruby_base_version, '2.0.0-p247'
set_default :ruby_patch_version, '2.0.0-p247'
set_default(:ruby_version) { "#{ruby_base_version}-#{ruby_patch_version}" }
set_default :server_os,    'ubuntu-12-04'

namespace :rbenv do
  desc 'Install rbenv, Ruby, and the Bundler gem'
  task :install, roles: :app do
    run "#{sudo} apt-get -y install curl git-core"
    run 'curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash'
    bashrc = <<-BASHRC
if [ -d ${HOME}/.rbenv ]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init -)"
fi
BASHRC
    put bashrc, '/tmp/rbenvrc'
    run 'cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp'
    run 'mv ~/.bashrc.tmp ~/.bashrc'
    run 'export PATH="${HOME}/.rbenv/bin:${PATH}"'
    run 'eval "$(rbenv init -)"'
    run "rbenv bootstrap-#{server_os}"
    run "rbenv install #{ruby_version}"
    run "rbenv global #{ruby_version}"
    run 'gem install bundler --no-ri --no-rdoc'
    run 'rbenv rehash'
  end
  after 'deploy:install', 'rbenv:install'
end
