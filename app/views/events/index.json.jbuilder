json.array!(@events) do |event|
  json.extract! event, :id, :ename, :edescription, :etime, :ecost
  json.url event_url(event, format: :json)
end
