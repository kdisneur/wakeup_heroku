def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def template(source, destination)
  erb = File.read(File.expand_path(File.join('..', 'templates', source), __FILE__))
  put(ERB.new(erb).result(binding), destination)
end

task :migrate do
  logger.info "We don't need to run migrations since we're using MongoDB"
end
