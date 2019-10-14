json.extract! search_result, :id, :search_term_id, :total, :created_at, :updated_at
json.url search_result_url(search_result, format: :json)
