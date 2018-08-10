def main
  start = ARGV[0].to_i
  last = ARGV[1].to_i
  (start..last).each do |n|
    puts "ruby aws_iot_scale_client.rb #{n.to_s.rjust(4,"0")} > /dev/null &"
  end
end

main
