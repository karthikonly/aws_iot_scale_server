aws_region = ENV['AWS_REGION'] || 'us-east-1'
aws_access_key_id = ENV['AWS_ACCESS_KEY_ID'] || 'AKIAIOT3XMRGRUFP4HYQ'
aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY'] || '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'

$aws_iot_client = Aws::IoT::Client.new(
  region: aws_region,
  credentials: Aws::Credentials.new(aws_access_key_id, aws_secret_access_key)
)
