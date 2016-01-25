json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :released
  json.url movie_url(movie, format: :json)
end
