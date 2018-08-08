# this is the client code for the scale server

require 'yaml'
require 'json'
require 'net/http'
require 'uri'
require 'securerandom'
require 'fileutils'
require 'mqtt'

# load the top level directory from yaml
# generate client id if not present
# create a working dir for this client if not present
def load_config
  $config = YAML::load_file('client_config.yaml')
  $config['connect']['full_url'] = $config['connect']['hostname'] + $config['connect']['provision_endpoint']
  $config['connect']['serial_number'] = ARGV[0] || SecureRandom.urlsafe_base64(6)
  $config['connect']['full_working_path'] = File.join($config['connect']['directory'], $config['connect']['serial_number'])
  FileUtils.mkdir_p($config['connect']['full_working_path'])
  Dir.chdir($config['connect']['full_working_path'])
  pp $config
  # pp Dir.pwd
end

# get a certificate for this serial number from API
# store the certificate in the files
def get_certs_from_server
  begin
    serial = $config['connect']['serial_number']
    uri = URI($config['connect']['full_url'])
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    req.body = { serial_number: serial }.to_json
    res = http.request(req)
    data = JSON.parse(res.body)
    IO.write("#{serial}-cert.pem", data["certificate"])
    IO.write("#{serial}-private.key", data["private_key"])
    IO.write("#{serial}-public.key", data["public_key"])
    pp data
  rescue => e
    puts "failed #{e}"
  end
end

def init_mqtt_client
  serial = $config['connect']['serial_number']
  client = MQTT::Client.new
  client.host = $config['mqtt']['aws_mqtt_endpoint']
  client.port = 8883
  client.ssl = true
  client.cert_file = "#{serial}-cert.pem"
  client.key_file  = "#{serial}-private.key"
  client.ca_file   = $config['mqtt']['ca_file_path']
  client.connect
  $client = client
end

# create thread to push data to common topic
def spawn_data_thread
  $data_thread = Thread.new { data_thread }
end

# use mqtt library to write data once in 15 seconds to common channel
def data_thread
  serial = $config['connect']['serial_number']
  while true do
    data = { message: Time.now.to_s, serial_number: serial }.to_json
    $client.publish($config['mqtt']['data_stream'], data, retain = false, qos = 1)
    p "published data: #{data}"
    sleep 15
  end
end

# create thread to listen to command stream of this client
def spawn_response_thread
  $response_thread = Thread.new { response_thread }
end

# response method for command stream
def response_thread
  serial = $config['connect']['serial_number']
  command_stream = $config['mqtt']['command_stream_prefix'] + "/" + serial
  response_stream = $config['mqtt']['response_stream_prefix'] + "/" + serial
  p "subscribed to: #{command_stream}"
  $client.subscribe(command_stream => 1)
  $client.get do |topic, message|
    p "command received from: #{topic} msg: #{message}"
    msg = JSON.parse(message)
    msg['serial_number'] = serial
    msg['recvd_time'] = Time.now.to_s
    $client.publish(response_stream, msg.to_json, retain = false, qos = 1)
    p "response data: #{msg}"
  end
end

# main method to start client
def main
  load_config
  get_certs_from_server
  init_mqtt_client
  spawn_data_thread
  spawn_response_thread
  $data_thread.join
  $response_thread.join
end

main