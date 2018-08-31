aws_region = ENV['AWS_REGION'] || 'us-east-1'
aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']

$aws_iot_client = Aws::IoT::Client.new(
  region: aws_region,
  credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key)
)