class ShirtRequestWorker
  include Sidekiq::Worker

  def perform(request_id)
    request = ShirtRequest.first!(id: request_id)

    lookup = nil

    begin
      lookup = Clearbit::Streaming::PersonCompany[email: request.email]
    rescue URI::InvalidURIError, Nestful::ResourceInvalid
    end

    request.update_all(lookup)
    Mailer.shirt_request!(request)
  end
end
