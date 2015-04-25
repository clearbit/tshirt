require_relative './config/setup'

error Sequel::ValidationFailed do
  hash = {
    error: {
      type:    'params_invalid',
      message: 'Invalid parameters.',
      messages: env['sinatra.error'].errors
    }
  }

  json(hash, 422)
end

helpers do
  def json(value, code = 200)
    status code
    content_type :json
    value.to_json
  end

  def selected(bool)
    bool ? ' selected' : ''
  end

  def errors_for(rec)
    return unless rec && rec.errors.any?

    errors = rec.errors.full_messages.map do |msg|
      "<li>#{h msg.humanize}</li>"
    end

    "<ul class=errors>#{errors.join}</ul>"
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def states
    Madison.states.inject({}) do |hash, state|
      hash.merge(state['abbr'] => state['name'])
    end
  end

  def asset_path(name)
    "/assets/#{settings.assets[name].digest_path}"
  end
end

get '/assets/*' do
  env['PATH_INFO'].sub!(%r{^/assets}, '')
  settings.assets.call(env)
end

post '/v1/requests' do
  shirt_request = ShirtRequest.create!(params.slice('email', 'size'))
  ShirtRequestWorker.new.perform(shirt_request.id)
  json shirt_request
end

get '/requests/:id' do
  @shirt = ShirtRequest.first!(id: params[:id])
  erb :request_confirm
end

post '/requests/:id/confirm' do
  @shirt = ShirtRequest.first!(id: params[:id])
  @shirt.set(request.params)
  @shirt.confirmed = true

  if @shirt.save
    erb :request_confirmed
  else
    erb :request_confirm
  end
end

get '/requests/:id/confirm' do
  @shirt = ShirtRequest.first!(id: params[:id])
  @shirt.confirmed = true

  if @shirt.save
    erb :request_confirmed
  else
    erb :request_confirm
  end
end
