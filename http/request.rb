require 'pry'

module Clarity
  module Http
    class Request
      # request line
      attr_reader :method
      attr_reader :target
      attr_reader :version

      # headers
      attr_reader :headers

      # body
      attr_reader :body

      def initialize
        @headers = {}
      end

      # parsing
      def parse(connection)
        read_request_line(connection)
        while read_header(connection); end
      end

      # debugging
      def to_s
        "#{method} #{target}\n" +
        "-\n" +
        headers.map { |n, v| "#{n}: #{v}\n" }.join +
        "#{body.nil? ? "" : "-\n#{body}"}"
      end

      private

      # parsing components
      REQUEST_LINE_FMT = /^(#{TOKEN}) ([^\s]+) HTTP\/([\d\.]+)#{CRLF}$/
      REQUEST_HEADER_FMT = /(#{TOKEN}): (.*)#{CRLF}/

      def read_request_line(conn)
        line = conn.gets(LF, 1024)
        line_tokens = match_line!(line, REQUEST_LINE_FMT)

        @method  = line_tokens[1]
        @target  = line_tokens[2]
        @version = line_tokens[3]
      end

      def read_header(conn)
        line = conn.gets(LF, 1024)

        is_header = line != CRLF
        if is_header
          line_tokens = match_line!(line, REQUEST_HEADER_FMT)

          # TODO: choose a prettier name format
          next_name  = line_tokens[1].upcase
          next_value = line_tokens[2]

          # join values for duplicated headers by ','
          prev_value = headers[next_name]
          unless prev_value.nil?
            next_value = "#{prev_value},#{next_value}"
          end

          headers[next_name] = next_value
        end

        is_header
      end

      def read_body
        line  = conn.gets(LF, 1024)
        @body = line
      end

      # helpers
      def match_line!(line, format)
        tokens = line.match(format)
        raise BadRequest if tokens.nil?
        tokens
      end
    end
  end
end
