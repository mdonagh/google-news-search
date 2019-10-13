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
    # session.visit 'https://www.google.com/'
    # session.fill_in 'q', :with => 'bear attack'
    # sleep_randomly
    # session.find_link('Google Search').first.click
    # sleep_randomly
    # session.click_link('News')
    # sleep_randomly
    session.visit 'https://www.google.com/search?q=dog+yoga&hl=en&tbm=nws&source=lnt&tbs=qdr:d'
    binding.pry
    session.click_link('Tools')
    results = session.find('#resultStats').text.split(' ')[1].gsub(/[\s,]/ ,"").to_i
    puts results.inspect
  end

  # This is to hide the fact that a script is doing this instead of a human by putting in pauses of random length
def sleep_randomly
  random_sleep = rand(5...10) * rand()
  sleep(random_sleep)
end 

end
