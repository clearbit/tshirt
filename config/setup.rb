require 'bundler'
Bundler.require(:default, (ENV['RACK_ENV'] || 'development').to_sym)

require 'sinatra'
require 'sinatra/sequel'
require 'apihub/contrib/sequel'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'

configure do
  set :database, ENV['DATABASE_URL'] ||
    "postgres://localhost:5432/tshirt_#{settings.environment}"

  configure do
    Mail.defaults do
      delivery_method :file
    end
  end

  configure :production do
    Mail.defaults do
      delivery_method :smtp, {
        address:        ENV['MAILGUN_SMTP_SERVER'],
        port:           ENV['MAILGUN_SMTP_PORT'],
        user_name:      ENV['MAILGUN_SMTP_LOGIN'],
        password:       ENV['MAILGUN_SMTP_PASSWORD'],
        domain:         'clearbit.com',
        authentication: :plain
      }
    end
  end
end

require_relative '../models/mailer'
require_relative '../models/shirt_request'
require_relative '../models/shirt_request_worker'
