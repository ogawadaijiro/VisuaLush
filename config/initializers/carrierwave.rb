CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_provider = 'fog/aws'
  config.fog_public = true
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    aws_secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: 'ap-northeast-1'
  }
  config.fog_directory  = Rails.application.credentials.dig(:aws, :s3_bucket_name)
end