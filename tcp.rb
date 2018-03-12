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
addresses = JSON.parse(params["addresses"]) if params["addresses"]
port = params["port"].to_i
timeout = params["timeout"].to_i
interval = params["interval"].to_i
max_tries = params["max_tries"].to_i

if (address == "" && addresses == []) || (address != "" && addresses != [])
  raise "must define either address or addresses"
end

addresses << address if address != ""
succeeded = []

tries = 0
loop do
  tries = tries + 1

  for a in addresses do
    next if succeeded.include? a
    succeeded << a if port_open?(a,port,timeout)
  end

  if succeeded.size == addresses.size
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
