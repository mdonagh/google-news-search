FactoryBot.define do
  
  factory :search_term do
    term { "Happy" } 
    timespan { "hour" }
    id { 1 }
    # last_check 
    check_frequency { 2 }
  end
end

# factory :search_term do
#   after(:build) do |search_term|
#     search_term = FactoryBot.build(:term "Sad", timespan: "day, check_frequency:("4"))
#   end
# end