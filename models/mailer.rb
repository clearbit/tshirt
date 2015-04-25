module Mailer extend self
  def request!(request)
    text = erb(:request_mail, locals: {request: request})
    html = markdown(text)

    Mail.deliver do
      from    'clearbit.com <team@clearbit.com>'
      to       request.email
      bcc      'sales+tshirt@clearbit.com'
      subject  'Clearbit TShirt ShirtRequest'

      text_part do
        body text
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body html
      end
    end
  end

  protected

  def erb(*args)
    app.erb(*args)
  end

  def markdown(*args)
    app.markdown(*args,
      fenced_code_blocks: true,
      smartypants: true,
      disable_indented_code_blocks: true,
      prettify: true,
      tables: true,
      with_toc_data: true,
      no_intra_emphasis: true
    )
  end

  def app
    Sinatra::Application.new!
  end
end
