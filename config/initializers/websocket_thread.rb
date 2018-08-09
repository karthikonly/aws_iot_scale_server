$websocket_status_thread = Thread.new {
  while true do
    serials = ThingCertificate.pluck(:serial_number)
    serials.each do |serial|
      hash = $redis.hgetall serial
      hash['serial_number'] = serial
      # p hash
      ActionCable.server.broadcast "status", hash
    end
    sleep 5
  end
}
