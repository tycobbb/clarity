require_relative './web/app'
require_relative './http/handler'

app = Clarity::Web::App.new
run(app)
