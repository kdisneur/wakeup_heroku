def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def template(source, destination)
  erb = File.read(File.expand_path(File.join('..', 'templates', source), __FILE__))
  put(ERB.new(erb).result(binding), destination)
end

namespace :deploy do
  desc 'Install all necessary stuff to have an environment up & running'
  task :install do
    packages.install
  end

  namespace :packages do
    desc 'Install all packages on the server'
    task :install do
      run "#{sudo} locale-gen en_US.UTF-8"
      run "#{sudo} aptitude -y update"
      packages = %w(safe-upgrade dialog curl git-core htop libcurl3 libcurl3-gnutls libcurl4-openssl-dev libcurl-openssl-dev libxml libxslt-dev memcached ntp redis-server)
      packages.each { |package| run "#{sudo} aptitude -o Dpkg::Options::=--force-confold -y install #{package}" }
    end

    desc 'Upgrade installed packages'
    task :upgrade do
      run "#{sudo} aptitude -y update"
      run "#{sudo} aptitude -y safe-upgrade"
    end
  end
end
