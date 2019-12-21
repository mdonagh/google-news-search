namespace :serp do
  task :run => :environment do
    SearchTerm.fetch_serp_totals
  end
end
