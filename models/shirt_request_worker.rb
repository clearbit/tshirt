class ShirtRequestWorker
  include Sidekiq::Worker

  def perform(request_id)
    request = ShirtRequest.first!(id: request_id)
    lookup  = Clearbit::Streaming::PersonCompany[email: request.email]
    request.update_all(lookup)
    Mailer.shirt_request!(request)
  end
end
