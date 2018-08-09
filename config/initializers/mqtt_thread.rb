$mqtt_client = MqttClient.new(
  aws_mqtt_endpoint: ENV['MQTT_ENDPOINT'] || "a1n5u982zrd0mu.iot.us-east-1.amazonaws.com",
  cert_file: "public/server-cert.pem",
  key_file: "public/server-private.key",
  ca_file: "public/verisign-root-ca.pem",
  data_stream_topic: "devices/data-stream",
  response_stream_prefix: "devices/response-stream"
)

$mqtt_listen_thread = Thread.new {
  $mqtt_client.process_messages
}
