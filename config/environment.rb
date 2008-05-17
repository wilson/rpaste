# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_web_service, :action_mailer ]
  config.action_controller.session_store = :active_record_store
  config.gem "syntax"
  
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_paste_session',
    :secret      => 'bb9f56d192b536458fe71e6fc7084f4c4540b6615d7b39f53a29f50317c9363d9b0fbb83a8449230ae9a21d72d091c8fed34126739a2c619f87971ff94e4b8a2'
  }
end
