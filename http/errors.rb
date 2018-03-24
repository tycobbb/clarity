module Clarity
  module Http
    class Error < StandardError
    end

    class BadRequest < Error
    end
  end
end
