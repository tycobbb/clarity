require_relative './router'

module Clarity
  module Web
    class App
      extend Router

      # entry point
      def call(rack_env)
        route = self.class.match(rack_env)

        if route.nil?
          [404, {}, []]
        else
          [200, {}, [route.call]]
        end
      end
    end
  end
end
