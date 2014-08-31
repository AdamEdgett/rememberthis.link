$LOAD_PATH << File.dirname(__FILE__)

require 'sinatra/base'
require 'sinatra/activerecord'
require 'protected_attributes'
require 'bcrypt'
require 'warden'
require 'sinatra/flash'
require 'haml'

require 'app/models/user'

class App < Sinatra::Base
  set :template_enginge, :haml
  set :environment, 'development'
  set :views, 'app/views'

  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash
  use Rack::Session::Cookie, secret: 'asdfn284rn23em92e0d2k3d02d2n32t3'
  use Warden::Manager do |config|
    config.serialize_into_session{|user| user.id }
    config.serialize_from_session{|id| User.find(id) }

    config.scope_defaults :default,
      strategies: [:password],
      action: 'unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
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
        fail!("Could not log in")
      end
    end
  end

  get '/' do
    if logged_in?
      haml :index, :locals => {current_user: current_user}
    else
      haml :login
    end
  end

  get '/signup' do
    not_login_required
    haml :signup
  end

  post '/signup' do
    new_user = User.create(params)
    if new_user.errors.present?
      flash[:error] = new_user.errors.messages.values.first.first
      redirect '/signup'
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
    haml :login
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
    redirect '/login'
  end

  post '/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
    puts env['warden.options'][:attempted_path]
    puts env['warden']
    flash[:error] = env['warden'].message || "You must log in"
    redirect '/login'
  end

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
