require_relative '../web/app'

class App < Clarity::Web::App
  get '/' do
    'hello, root'
  end

  get '/test' do
    'hello, test'
  end
end
