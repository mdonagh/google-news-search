class GetSerpJob < ApplicationJob
  queue_as :default

  def perform(search_term_id)
    search_term = SearchTerm.find(search_term_id)
    search_url = get_search_url(search_term.term, search_term.timespan)

    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end

    Capybara.register_driver :headless_chrome do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w(no-sandbox disable-dev-shm-usage headless) },
        loggingPrefs: { browser: 'ALL' }
      )

      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities
      end

    Capybara.default_max_wait_time = 5
    Capybara.javascript_driver = :headless_chrome # :chrome simulates behavior in browser
    Capybara.server_port = 31337 + ENV['TEST_ENV_NUMBER'].to_i
    Capybara.configure do |config|
      config.always_include_port = true
    end

    session = Capybara::Session.new(:headless_chrome)
    puts search_url
    session.visit search_url
    puts session.body
    result_total = session.find('#resultStats', visible: 'hidden').base.all_text.split(' ')[1].gsub(/[\s,]/ ,"").to_i
    SearchResult.create(search_term: search_term, total: result_total)
    search_term.update(last_check: Time.now)
    Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  end

  def get_search_url(search_term, timespan)
    search_query = search_term.split(' ').join('+')
    timespan_param = get_timespan_url_param(timespan)
    "https://www.google.com/search?q=#{search_query}&hl=en&tbm=nws&source=lnt#{timespan_param}"
  end

  def get_timespan_url_param(timespan)
    case timespan
      when 'hour'
        "&tbs=qdr:h"
      when 'day'
        "&tbs=qdr:d"
      when 'week'
        "&tbs=qdr:w"
      when 'month'
        "&tbs=qdr:m"
      when 'year'
        "&tbs=qdr:y"
      else
        ""
      end
  end
end
