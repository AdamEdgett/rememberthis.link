class App < Sinatra::Base
  def login_required
    if current_user
      true
    else
      session[:return_to] = request.fullpath
      redirect '/login'
      false
    end
  end

  def not_login_required
    if current_user
      redirect '/'
    end
  end

  def current_user
    if logged_in?
      User.find(session[:user])
    end
  end

  def logged_in?
    session[:user].present?
  end
end
