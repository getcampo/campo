CarrierWave.configure do |config|
  case ENV['STORAGE_SERVICE']
  when 'aws'
    require 'carrierwave-aws'
    config.storage = :aws
    config.aws_bucket = ENV.fetch('STORAGE_AWS_BUCKET')
    config.aws_acl = 'public-read'
    config.aws_credentials = {
      access_key_id: ENV.fetch('STORAGE_AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('STORAGE_AWS_SECRET_ACCESS_KEY'),
      region: ENV.fetch('STORAGE_AWS_REGION')
    }
  when 'gcloud'
    require 'carrierwave-google-storage'
    require 'google/cloud/storage'
    config.storage = :gcloud
    config.gcloud_bucket = ENV['STORAGE_GCLOUD_BUCKET']
    config.gcloud_bucket_is_public = true
    config.gcloud_credentials = {
      gcloud_project: ENV['STORAGE_GCLOUD_PROJECT'],
      gcloud_keyfile: ENV['STORAGE_GCLOUD_KEYFILE'] || JSON.parse(ENV['STORAGE_GCLOUD_KEYFILE_CONTENT'])
    }
  else
    config.storage = :file
  end
end
