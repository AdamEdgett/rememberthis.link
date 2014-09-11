$LOAD_PATH << File.dirname(__FILE__)

require 'sinatra/base'
require 'sinatra/activerecord'
require 'protected_attributes'
require 'bcrypt'
require 'warden'
require 'sinatra/flash'

require 'app/models'
require 'app/routes'

# Main app file
class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Flash
  use Rack::Session::Cookie, secret: 'asdfn284rn23em92e0d2k3d02d2n32t3'

  set :template_enginge, :haml
  set :environment, :development
  set :views, 'app/views'
  set :public_folder, 'app/assets'
end
