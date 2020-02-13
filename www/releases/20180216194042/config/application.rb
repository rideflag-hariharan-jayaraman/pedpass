require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pedestrian
  class Application < Rails::Application
    config.api_only = false
    config.load_defaults 5.1

    # Load modules in the /lib folder
    config.autoload_paths += %W(#{config.root}/lib/*)
    # Make sure classy_enum enums get loaded
    config.autoload_paths += %W(#{config.root}/app/enums)


    # Set Mailer Preview Path
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # Add stylesheets path to assets
    config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
    config.assets.precompile += %w( forms.css )

    # define locales
    config.i18n.available_locales = [:en, :es, :fr]
  end
end
