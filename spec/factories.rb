FactoryBot.define do
  
  factory :search_term do
    term { "Happy" } 
    timespan { "hour" }
    last_check 
    check_frequency { 2 }
  end
end