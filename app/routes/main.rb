require_relative 'helpers'

class App < Sinatra::Base
  get '/' do
    if logged_in?
      haml :index, :locals => {current_user: current_user}
    else
      haml :login
    end
  end

  post '/tags' do
    Tag.create(text: params['text'], user: user)
    redirect '/'
  end

  post '/links' do
    tags = []
    if params.key?('tags') && params['tags'].present?
      params['tags'].split(',').each do |tag|
        tags.push(Tag.find_or_create_by(text: tag, user: user))
      end
    end
    Link.create(title: params['title'], url: params['url'], user: user, tags: tags)
    redirect '/'
  end
end
