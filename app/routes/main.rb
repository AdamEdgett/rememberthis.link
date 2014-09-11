require_relative 'helpers'

# Includes routes for main app functionality
class App < Sinatra::Base
  get '/' do
    if logged_in?
      haml :home, locals: { current_user: current_user }
    else
      haml :landing, layout: :'layouts/landing'
    end
  end

  post '/tags' do
    Tag.create(text: params['text'], user: user)
    redirect '/'
  end

  get '/tag/:text' do
    tag = Tag.find_by(text: params[:text], user: user)
    links = Link.all.select { |l| l.tags.include?(tag) }
    haml :tag, locals: { links: links, tag: tag }
  end

  post '/links' do
    tags = []
    if params.key?('tags') && params['tags'].present?
      params['tags'].split(',').each do |tag|
        tags.push(Tag.find_or_create_by(text: tag, user: user))
      end
    end
    Link.create(title: params['title'],
                url: params['url'],
                user: user,
                tags: tags)
    redirect '/'
  end
end
