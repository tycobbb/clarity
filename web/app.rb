module Clarity
  module Web
    class App
      # entry point
      def call(rack_env)
        puts 'hello, app'
        return [200, {}, '']
      end

      # endpoints
      def self.get(path)
      end
    end
  end
end
