# Logic for authentication
class App < Sinatra::Base
  get '/signup' do
    not_login_required
    haml :signup, layout: :'layouts/landing'
  end

  post '/signup' do
    new_user = User.create(params)
    if new_user.errors.present?
      flash[:error] = new_user.errors.messages.values.first.first
      redirect '/'
    else
      env['warden'].authenticate!

      flash[:success] = env['warden'].message

      if session[:return_to].nil?
        redirect '/'
      else
        redirect session[:return_to]
      end
    end
  end

  get '/login' do
    not_login_required
    haml :login, layout: :'layouts/landing'
  end

  post '/login' do
    env['warden'].authenticate!

    flash[:success] = env['warden'].message

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash[:success] = 'Successfully logged out'
    puts current_user
    redirect '/'
  end

  post '/unauthenticated' do
    if session[:return_to].nil?
      session[:return_to] = env['warden.options'][:attempted_path]
    end
    puts env['warden.options'][:attempted_path]
    puts env['warden']
    flash[:error] = env['warden'].message || 'You must log in'
    redirect '/'
  end

  use Warden::Manager do |config|
    config.serialize_into_session(&:id)
    config.serialize_from_session { |id| User.find(id) }

    config.scope_defaults :default,
      strategies: [:password],
      action: 'unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params && params['email'] && params['password']
    end

    def authenticate!
      if user = User.authenticate(params['email'], params['password'])
        session[:user] = user.id
        success!(user)
      else
        fail!('Could not log in')
      end
    end
  end
end
