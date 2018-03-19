require 'rack'
require 'socket'
require 'pry'

DEFAULT_RESPONSE = %[
HTTP/1.1 200 OK

hello, world
]

module Clarity
  module Http
    class Server
      HOST = '127.0.0.1'
      PORT = 8080
      REQUEST_QUEUE_SIZE = 1

      def initialize(app)
        @app = app
      end

      def start
        puts 'clarity-http'
        puts '------------'
        puts "- listening on #{PORT}"

        loop do
          # handle request
          connection, address = socket.accept

          puts "\nrequest"
          puts '-------'
          puts "- address: #{address.inspect}"
          rack_result = handle_in(connection)

          puts "\nresponse"
          print '--------'
          handle_out(connection, rack_result)

          connection.close
        end
      end

      private

      attr_reader :app

      def handle_in(connection)
        request = connection.recv(1024)
        puts "\n#{request}"

        # build rack environment for this request
        env = build_rack_env(request)
        # get result from the rack app
        app.call(env)
      end

      def handle_out(connection, rack_result)
        response = DEFAULT_RESPONSE
        puts response

        connection.send(response, 0)
      end

      def build_rack_env(request)
        lines = request.split("\r\n")

        env = {
          'REQUEST_METHOD'    => 'GET',
          'SCRIPT_NAME'       => '',
          'PATH_INFO'         => lines[0].split[1],
          'QUERY_STRING'      => '',
          'SERVER_NAME'       => 'localhost',
          'SERVER_PORT'       => '8080',
          'rack.version'      => Rack.version.split('.'),
          'rack.url_scheme'   => 'http',
          'rack.input'        => create_io_buffer,
          'rack.errors'       => create_io_buffer,
          'rack.multithread'  => false,
          'rack.multiprocess' => false,
          'rack.run_once'     => false
        }

        env
      end

      def socket
        @socket ||= begin
          socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
          socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
          socket.bind(Socket.sockaddr_in(PORT, HOST))
          socket.listen(REQUEST_QUEUE_SIZE)
          socket
        end
      end

      def create_io_buffer
        buffer = StringIO.new('')
        buffer.set_encoding(Encoding::ASCII_8BIT)
        buffer
      end
    end
  end
end
