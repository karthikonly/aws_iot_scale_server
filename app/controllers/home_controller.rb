class HomeController < ApplicationController

  def index
  end

  def get_credentials
    serial = params[:serial_number]
    thing_cert = ThingCertificate.find_by(serial_number: serial)
    if thing_cert
      render json: thing_cert
    else
      # TODO: implement the aws API calls for creating a certificate
    end
  end

  def issue_command
    serial = params[:serial_number]
    command = params[:command] || "command-001"
    command_channel = "devices/command-stream/#{serial}"
    $redis.hset serial, :command, command
    $redis.hset serial, :issue_time, Time.now.to_s
    $mqtt_client.mqtt_client.publish(command_channel, {command: command}.to_json, retain = false, qos = 1)
  end
end
