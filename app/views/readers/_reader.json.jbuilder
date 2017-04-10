json.extract! reader, :id, :first_name, :last_name, :second_name, :birthdate, :avatar, :created_at, :updated_at
json.url reader_url(reader, format: :json)
