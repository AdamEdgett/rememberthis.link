require_relative 'app'

project_path         = Sinatra::Application.root

http_path             = '/'
http_stylesheets_path = '/stylesheets'
http_images_path      = '/images'
http_javascripts_path = '/javascripts'

sass_dir              = File.join 'public', 'sass'
css_dir               = File.join 'public', 'css'
images_dir            = File.join 'public', 'img'
javascripts_dir       = File.join 'public', 'js'

preferred_syntax      = :scss

line_comments         = false
output_style          = :compact
