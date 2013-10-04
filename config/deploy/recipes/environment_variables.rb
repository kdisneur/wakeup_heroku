set_default(:environment_variables_paths) { ['.env', ".env.#{stage}"] }
namespace :environment_variables do
  desc 'Copy all the environment variables to the server'
  task :copy do
    environment_variables_paths.each do |file|
      next unless File.exists?(file)

      transfer :up, file, File.join(shared_path, file), via: :scp
    end
  end
  after 'deploy:finalize_update', 'environment_variables:copy'

  task :symlink do
    environment_variables_paths.each do |file|
      next unless File.exists?(file)

      run "ln -fs #{File.join(shared_path, file)} #{release_path}/#{file}"
    end
  end
  after 'environment_variables:copy', 'environment_variables:symlink'
end
