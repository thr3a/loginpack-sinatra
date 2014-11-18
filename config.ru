require './app.rb'

if ENV['RAILS_RELATIVE_URL_ROOT']
  map ENV['RAILS_RELATIVE_URL_ROOT'] do
    run Sinatra::Application
  end
else
  run Sinatra::Application
end