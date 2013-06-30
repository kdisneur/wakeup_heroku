if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider          = 'AWS'
    config.aws_access_key_id     = ENV['AWS_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.fog_directory         = ENV['FOG_DIRECTORY']
    config.fog_region            = 'eu-west-1'
    config.gzip_compression      = true
  end
end
