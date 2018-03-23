require_relative './app/app'
require_relative './rack/handler/clarity'

run(App.new)
