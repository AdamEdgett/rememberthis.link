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
    login_required
    Tag.create(text: params['text'], user: user)
    redirect '/'
  end

  get '/tags/:text' do
    login_required
    tag = Tag.find_by(text: params[:text], user: user)
    links = Link.all.select { |l| l.tags.include?(tag) }
    haml :tag, locals: { links: links, tag: tag }
  end

  get '/tags/:text/edit' do
    login_required
    tag = Tag.find_by(text: params[:text], user: user)
    haml :edit_tag, locals: { tag: tag }
  end

  post '/tags/:text' do
    login_required
    tag = Tag.find_by(text: params[:text], user: user)
    tag.text = params[:new_text]
    tag.save
    redirect "/tags/#{params[:new_text]}"
  end

  get '/tags/:text/delete' do
    login_required
    tag = Tag.find_by(text: params[:text], user: user)
    tag.destroy
    redirect '/'
  end

  post '/links' do
    login_required
    tags = parse_tags(params['tags'])
    Link.create(title: params['title'],
                url: params['url'],
                user: user,
                tags: tags)
    redirect '/'
  end

  get '/links/:id' do
    login_required
    link = Link.find_by(id: params[:id], user: user)
    haml :link, locals: { link: link }
  end

  get '/links/:id/edit' do
    login_required
    link = Link.find_by(id: params[:id], user: user)
    haml :edit_link, locals: { link: link }
  end

  post '/links/:id' do
    login_required
    link = Link.find_by(id: params[:id], user: user)
    link.title = params[:new_title]
    link.url = params[:new_url]
    link.tags = parse_tags(params[:tags])
    link.save
  end

  get '/links/:id/delete' do
    login_required
    link = Link.find_by(id: params[:id], user: user)
    link.destroy
    redirect '/'
  end
end
