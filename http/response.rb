require 'pry'

module Clarity
  module Http
    class Response
      attr_reader :status
      attr_reader :headers
      attr_reader :body

      def initialize(status, headers, body)
        @status = status
        @headers = headers
        @body = body
      end

      # serialization
      def serialize
        @output ||= begin
          response = serialize_metadata

          body.each do |line|
            response += line
          end

          response
        end
      end

      # debugging
      def to_s
        serialize
      end

      private

      def serialize_metadata
        "HTTP/1.1 #{status} #{status_name}#{CRLF}" +
        headers.map { |n, v| "#{n}: #{v}#{CRLF}" }.join +
        "#{CRLF}"
      end

      def status_name
        case status
        when 200
          'OK'
        else
          'Not Found'
        end
      end
    end
  end
end
