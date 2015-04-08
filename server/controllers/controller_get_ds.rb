get '/get_ds' do
  @ds_types = DeliverySiteType.all
  @environments = DeliverySiteType.get_environments
  @stock = DeliverySite.get_stock
  erb :get_ds
end

get '/get_ds/:type/:environment' do
  @delivery_site, @status, @reason = DeliverySite.get_one(params[:type], params[:environment])
  @ds_types = DeliverySiteType.all
  @environments = DeliverySiteType.get_environments
  @stock = DeliverySite.get_stock
  erb :get_ds
end
