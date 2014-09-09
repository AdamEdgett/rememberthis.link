# Helper functions
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
    redirect '/' if current_user
  end

  def current_user
    User.find(session[:user]) if logged_in?
  end

  def logged_in?
    session[:user].present?
  end

  def user
    params['user'].present? ? params['user'] : current_user
  end
end
