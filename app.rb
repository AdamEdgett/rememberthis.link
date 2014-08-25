require 'rubygems'
require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require 'digest/sha1'
require 'sinatra-authentication'
require 'sinatra/flash'
require 'haml'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/app.db")
DataMapper.auto_upgrade!

class App < Sinatra::Base
  set :template_enginge, :haml
  set :environment, 'development'
  set :views, 'views'

  use Rack::Session::Cookie, secret: 'asdfn284rn23em92e0d2k3d02d2n323'
  register Sinatra::Flash
  register Sinatra::SinatraAuthentication

  get '/' do
    login_required
    haml 'home', :layout => :layout
  end

end
