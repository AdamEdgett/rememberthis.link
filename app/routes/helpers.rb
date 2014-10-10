# Helper functions
class App < Sinatra::Base
  def login_required
    if current_user
      true
    else
      session.delete(:user)
      session[:return_to] = request.fullpath
      redirect '/'
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
    session[:user].present? && User.exists?(session[:user])
  end

  def user
    params['user'].present? ? params['user'] : current_user
  end

  def parse_tags(tags)
    tags.scan(/\w+/).map do |tag|
      Tag.find_or_create_by(text: tag, user: user)
    end
  end

end
