require "rails_helper"

RSpec.describe GetSerpJob do

  search_term = FactoryBot.create(:search_term)
  
  it "matches with enqueued job" do   
    ActiveJob::Base.queue_adapter = :test
    expect {
      GetSerpJob.perform_later(search_term.id)
    }.to have_enqueued_job(GetSerpJob)
  end

  it "matches with enqueued job time" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      GetSerpJob.set(:wait_until => Date.tomorrow.noon).perform_later(search_term.id)
    }.to have_enqueued_job.at(Date.tomorrow.noon)
  end

  it "matches number of jobs scheduled" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      3.times { GetSerpJob.perform_later(search_term.id)}
    }.to have_enqueued_job(GetSerpJob).at_least(2).times
  end

end