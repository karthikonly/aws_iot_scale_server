class HomeController < ApplicationController

  def index
  end

  def get_credentials
    serial = params[:serial_number]

    thing_cert = ThingCertificate.find_by(serial_number: serial)

    unless thing_cert
      # create database entry
      thing_cert = ThingCertificate.new(serial_number: serial)
      # create certificate and get keys
      resp = $aws_iot_client.create_keys_and_certificate(set_as_active: true)
      logger.info "create_keys"
      cert_arn = resp.certificate_arn
      thing_cert.public_key = resp.key_pair.public_key
      thing_cert.private_key = resp.key_pair.private_key
      thing_cert.certificate = resp.certificate_pem
      thing_name = "karthik-thing-#{serial}"
      $aws_iot_client.create_thing({
         thing_name: thing_name,
         thing_type_name: "karthik-thing-type",
         attribute_payload: {
           attributes: {
             "model-number" => "model-a",
             "serial-number" => serial
           },
           merge: false
         }
      })
      logger.info "create_thing"
      # attach certificate to thing
      $aws_iot_client.attach_thing_principal({
         thing_name: thing_name,
         principal: cert_arn
      })
      logger.info "attach thing to cert"
      # attach policy to certificate
      $aws_iot_client.attach_policy({
        policy_name: "karthik-policy",
        target: cert_arn
      })
      logger.info "attach policy to cert"

      thing_cert.save
    end

    render json: thing_cert
  end

  def issue_command
    serial = params[:serial_number]
    command = params[:command] || "command-001"
    command_channel = "devices/command-stream/#{serial}"
    $redis.hset serial, :command, command
    $redis.hset serial, :issue_time, Time.now.to_s
    $mqtt_client.mqtt_client.publish(command_channel, {command: command}.to_json, retain = false, qos = 1)
    render json: { status: 'success'}
  end
end
