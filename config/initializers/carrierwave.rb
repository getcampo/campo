CarrierWave.configure do |config|
  case ENV['STORAGE_SERVICE']
  when 'aws'
    config.storage = :aws
    config.aws_bucket = ENV.fetch('STORAGE_AWS_BUCKET')
    config.aws_acl = 'public-read'
    config.aws_credentials = {
      access_key_id: ENV.fetch('STORAGE_AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('STORAGE_AWS_SECRET_ACCESS_KEY'),
      region: ENV.fetch('STORAGE_AWS_REGION')
    }
  else
    config.storage = :file
  end
end
