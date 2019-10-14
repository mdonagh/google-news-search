json.extract! search_term, :id, :term, :timespan, :last_check, :check_frequency, :created_at, :updated_at
json.url search_term_url(search_term, format: :json)
