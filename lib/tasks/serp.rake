namespace :serp do
  task :run do
    SearchTerm.all.each do |search_term|
      GetSerpJob.perform_later(search_term.id)
    end
  end
end
