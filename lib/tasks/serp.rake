namespace :serp do

  desc "TODO"
  task :get => :environment do
require "selenium/webdriver"

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
    session = Capybara::Session.new(:selenium_chrome_headless)
    session.visit 'https://www.google.com/search?q=dog+yoga&hl=en&tbm=nws&source=lnt&tbs=qdr:d'
    results = session.find('#resultStats', visible: 'hidden').base.all_text.split(' ')[1].gsub(/[\s,]/ ,"").to_i
    puts results.inspect
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
  # This is to hide the fact that a script is doing this instead of a human by putting in pauses of random length
def sleep_randomly
  random_sleep = rand(5...10) * rand()
  sleep(random_sleep)
end 

end
