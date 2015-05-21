require './app'

run APIHub::Contrib::Service.app('tshirt') { run Sinatra::Application }
