require 'socket'

HOST = '127.0.0.1'
PORT = 8080

# setup socket to listen on host and port
socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
socket.bind(Socket.sockaddr_in(PORT, HOST))
socket.listen(1)

# main
puts 'clarity-http'
puts '------------'
puts "- listening on #{PORT}"

loop do
  # get request
  connection, address = socket.accept
  puts "\nrequest"
  puts '-------'
  puts "- address: #{address.inspect}"

  request = connection.recv(1024)
  puts "\n#{request}"

  # send response
  response = %[
HTTP/1.1 200 OK

hello, world
  ]

  puts "\nresponse"
  print '--------'
  puts response

  connection.send(response, 0)
  connection.close
end
