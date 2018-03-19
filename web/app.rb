module Clarity
  module Web
    class App
      def call(rack_env)
        puts 'hello, app'
        return [200, {}, '']
      end
    end
  end
end
