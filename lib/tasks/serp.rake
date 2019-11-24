namespace :serp do
  task :run => :environment do
    SearchTerm.all.each do |search_term|
      time_to_run = search_term.check_frequency
      while time_to_run < 60
        GetSerpJob.delay(run_at: time_to_run.minutes.from_now).perform_later(search_term.id)
        time_to_run = time_to_run + search_term.check_frequency 
      end
    end
  end
end
