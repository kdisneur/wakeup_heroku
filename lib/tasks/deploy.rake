namespace :deploy do
  desc "sync environment variables to Open Shift"
  task :sync_environment_variables do
    file_path = Rails.root.join('tmp', 'environment_variables')
    File.open(file_path, 'w') do |file|
      Figaro.env.each { |key, value| file.puts("export #{key}=#{value}") }
    end

    unless system("scp #{file_path} #{ENV['host']}:app-root/data/.environment")
      puts 'SCP failed'
    end

    File.delete(file_path)
  end
end
