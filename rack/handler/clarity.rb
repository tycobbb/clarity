require 'rack'
require_relative '../../http/server'

module Rack
  module Handler
    module Clarity
      def self.run(app, options = {})
        server = ::Clarity::Http::Server.new(app)
        server.start
      end
    end

    register :clarity, Clarity
  end
end
