require './app'

map '/v1/status' do
  use APIHub::Contrib::Middleware::Status, service: 'tshirt'
  run ->(_env) { [400, { 'Content-Type' => 'text/plain' }, ['Application not found']] }
end

map '/' do
  use Sinatra::CommonLogger
  run Sinatra::Application
end
