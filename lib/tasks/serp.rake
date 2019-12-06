namespace :serp do
  task :run => :environment do
    SearchTerm.all.each do |search_term|
      per_day = search_term.check_frequency 
      frequency = 24 / per_day
      GetSerpJob.delay(run_at: frequency.hours.from_now).perform_later(search_term.id)
    end
  end
end
