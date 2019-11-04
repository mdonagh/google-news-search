require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Serp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.active_job.queue_adapter = :delayed_job
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    WillPaginate.per_page = 10

    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end

    Capybara.register_driver :headless_chrome do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w( disable-gpu) }
        )

      Capybara::Selenium::Driver.new app,
      browser: :chrome,
      desired_capabilities: capabilities
    end

    Capybara.javascript_driver = :headless_chrome
  end
end
