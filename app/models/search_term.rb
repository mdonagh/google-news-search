class SearchTerm < ApplicationRecord
  has_many :search_results

  def self.fetch_serp_totals 
    SearchTerm.all.each do |search_term|
      check_interval = 24 / search_term.check_frequency
      check_time = 0
      while check_time < 24
        GetSerpJob.delay(run_at: check_time.hours.from_now).perform_later(search_term.id)
        check_time = check_time + check_interval
      end
    end
  end
end
