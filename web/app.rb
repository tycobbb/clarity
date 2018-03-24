module Clarity
  module Web
    class App
      # entry point
      def call(rack_env)
        return [200, {}, ['hello, app']]
      end

      # endpoints
      def self.get(path)
      end
    end
  end
end
