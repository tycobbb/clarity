module Clarity
  module Http
    # line endings
    CR = "\r"
    LF = "\n"
    CRLF = "#{CR}#{LF}"

    # request tokens
    TOKEN_CHAR = /[!#$%&'*+-.^_`|~\w\d]/.source
    TOKEN = /[#{TOKEN_CHAR}]+/.source
  end
end
