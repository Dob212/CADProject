json.array!(@orders) do |order|
  json.extract! order, :id, :oname, :odescription, :otime, :ocost, :profile_id
  json.url order_url(order, format: :json)
end
