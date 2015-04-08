post '/get_ds_ws' do
  delivery_site, status, reason = DeliverySite.get_one(params[:type], params[:environment])
  {
      :status => status,
      :reason => reason,
      :ds_id => delivery_site.id,
      :ds_type => params[:type],
      :environment => params[:environment],
  }.to_json
end