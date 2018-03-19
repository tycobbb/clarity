require 'rack'
require_relative './server'

module Clarity
  module Http
    module Handler
      def self.run(app, options = {})
        server = Server.new(app)
        server.start
      end
    end
  end
end

Rack::Handler.register('clarity-http', 'Clarity::Http::Handler')
