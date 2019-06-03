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
  when 'gcloud'
    require 'google/cloud/storage'
    config.storage = :gcloud
    config.gcloud_bucket = ENV['STORAGE_GCLOUD_BUCKET']
    config.gcloud_bucket_is_public = true
    config.gcloud_credentials = {
      gcloud_project: ENV['STORAGE_GCLOUD_PROJECT'],
      gcloud_keyfile: Google::Cloud::Storage::Credentials.new({
        type: 'service_account',
        project_id: ENV['STORAGE_GCLOUD_PROJECT_ID'],
        private_key_id: ENV['STORAGE_GCLOUD_PRIVATE_KEY_ID'],
        private_key: ENV['STORAGE_GCLOUD_PRIVATE_KEY'],
        client_email: ENV['STORAGE_GCLOUD_CLIENT_EMAIL'],
        client_id: ENV['STORAGE_GCLOUD_CLIENT_ID'],
        auth_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_uri: 'https://accounts.google.com/o/oauth2/token',
        auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
        client_x509_cert_url: ENV['STORAGE_GCLOUD_CLIENT_X509_CERT_URL']
      })
    }
  else
    config.storage = :file
  end
end
