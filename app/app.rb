require_relative '../web/app'

class App < Clarity::Web::App
  get('/test') do
    return 'hello, test'
  end
end
