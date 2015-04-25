require 'bundler'
Bundler.require(:default, (ENV['RACK_ENV'] || 'development').to_sym)

require 'sinatra'
require 'sinatra/sequel'
require 'apihub/contrib/sequel'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'
require 'stylus/sprockets'

configure do
  set :root, File.expand_path('../..', __FILE__)

  set :database, ENV['DATABASE_URL'] ||
    "postgres://localhost:5432/tshirt_#{settings.environment}"

  configure do
    Mail.defaults do
      delivery_method :file
    end
  end

  configure :staging do
    Mail.defaults do
      delivery_method :smtp, {
        address: 'smtp-staging.clearbit.io',
        port:    1025
      }
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

  set :show_exceptions, :after_handler
  set :erb, escape_html: true

  set :assets, assets = Sprockets::Environment.new(settings.root)
  assets.append_path('assets/stylesheets')
  assets.cache = Sprockets::Cache::FileStore.new(File.join(settings.root, 'tmp'))
  Stylus.setup(assets)
end

require_relative '../models/mailer'
require_relative '../models/shirt_request'
require_relative '../models/shirt_request_worker'
