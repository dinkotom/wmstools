helpers HelpersMain

get '/' do
  redirect '/test_runner'
end

get '/change_log' do
  erb :change_log
end