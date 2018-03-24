require 'rack'
require 'socket'
require_relative './utils'
require_relative './errors'
require_relative './request'
require_relative './response'

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
        puts "- listening on #{PORT}\n"

        loop do
          connection, address = socket.accept
          rack_result = handle_in(connection)
          handle_out(connection, rack_result)
          connection.close
        end
      end

      private

      attr_reader :app

      def handle_in(connection)
        request = Request.new
        request.parse(connection)

        puts "\n--> in\n"
        puts "\n#{request.to_s.chomp}\n"

        # build rack environment for this request
        env = build_rack_env(request)
        # get result from the rack app
        app.call(env)
      end

      def handle_out(connection, rack_result)
        response = Response.new(*rack_result)

        puts "\n<-- out\n"
        puts "\n#{response.to_s.chomp}\n"

        connection.send(response.serialize, 0)
      end

      def build_rack_env(request)
        env = {
          'REQUEST_METHOD'    => request.method,
          'SCRIPT_NAME'       => '',
          'PATH_INFO'         => request.target,
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

        request.headers.each do |name, value|
          env["HTTP_#{name}"] = value
        end

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
