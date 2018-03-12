require 'json'

require 'socket'
require 'timeout'

def port_open?(address, port, seconds=1)
  Timeout::timeout(seconds) do
    begin
      TCPSocket.new(address, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      false
    end
  end
rescue Timeout::Error
  false
end

params = JSON.parse(STDIN.read)
address = params["address"]
port = params["port"].to_i
timeout = params["timeout"].to_i
interval = params["interval"].to_i
max_tries = params["max_tries"].to_i

tries = 0
loop do
  tries = tries + 1

  if port_open?(address,port,timeout)
    result = {
      tries: tries.to_s
    }
    puts result.to_json
    exit 0
  end

  if tries > max_tries
    raise "max tries #{max_tries} exceeded"
  end

  sleep interval
end
