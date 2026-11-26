# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development or test environment
if ["development", "test"].include? ENV["RAILS_ENV"]
  Dotenv::Railtie.load
end

module Granite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    config.action_controller.raise_on_open_redirects = false
    config.action_mailer.deliver_later_queue_name = :mailers
    config.active_job.queue_adapter = :sidekiq

    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Rails 7.2 removed Rails.application.secrets; this reads config/secrets.yml.
    def secrets
      @_secrets ||= config_for(:secrets)
    end
  end
end
