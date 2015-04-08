require_relative('../helpers/helpers_piazza')
include HelpersPiazza

get '/piazza' do
  output = String.new
  PiazzaScreen.all.each do |screen|
    output << "<a href=\"/piazza/#{screen.screen_number}\">"
    screen.environments.each do |environment|
      output << "#{environment.wms_version_name} (#{environment.name}), "
    end
    output = output[0..-3]
    output << '</a><br>'
  end
  output
end

get '/piazza/:screen_number' do
  piazza_screen = PiazzaScreen.get(params[:screen_number])
  if piazza_screen
    @piazza_data = get_piazza_data(piazza_screen.screen_number)
    @overall_result = @piazza_data[:screen][:overall_result]
    @any_test_running = @piazza_data[:screen][:anything_running?]
    @refresh_interval = PIAZZA_REFRESH_INTERVAL
    erb :piazza, :layout => false
  else
    "Piazza screen '#{params[:screen_number]}' does not exist"
  end
end


get '/piazza_content/:screen_number' do
  piazza_screen = PiazzaScreen.get(params[:screen_number])
  if piazza_screen
    @piazza_data = get_piazza_data(piazza_screen.screen_number)
    erb :piazza_content, :layout => false
  else
    "Piazza screen '#{params[:screen_number]}' does not exist"
  end
end

