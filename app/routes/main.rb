class App < Sinatra::Base
  get '/' do
    if logged_in?
      haml :index, :locals => {current_user: current_user}
    else
      haml :login
    end
  end
end
