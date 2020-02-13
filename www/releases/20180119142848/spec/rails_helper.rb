require 'simplecov'

SimpleCov.profiles.define 'rails-api' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/app/controllers/admin'
  add_filter '/app/dashboards'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  add_group 'Serializers', 'app/serializers'
end

SimpleCov.start 'rails-api'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end

require 'spec_helper'
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError
  `RAILS_ENV=test bin/rails db:migrate`
end

RSpec.configure do |config|
  config.include AuthorizationHelper

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }

  config.before(:each, type: :feature) do
    if Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) { DatabaseCleaner.start }
  config.append_after(:each) { DatabaseCleaner.clean }
end
