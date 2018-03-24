module Clarity
  module Web
    module Router
      # routing
      def get(path, &block)
        routes["GET #{path}"] = block
      end

      # matching
      def match(env)
        routes["#{env['REQUEST_METHOD']} #{env['PATH_INFO']}"]
      end

      private

      def routes
        @routes ||= {}
      end
    end
  end
end
