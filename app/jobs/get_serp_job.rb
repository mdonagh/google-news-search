class GetSerpJob < ApplicationJob
  queue_as :default

  def perform(search_term_id)
    search_term = SearchTerm.find(search_term_id)
    search_url = get_search_url(search_term.term, search_term.timespan)
    session = Capybara::Session.new(:selenium_chrome_headless)
    session.visit search_url
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
