require_relative 'app'

project_path         = Sinatra::Application.root

http_path             = '/'
http_stylesheets_path = '/stylesheets'
http_images_path      = '/images'
http_javascripts_path = '/javascripts'

sass_dir              = File.join 'app', 'assets', 'sass'
css_dir               = File.join 'app', 'assets', 'css'
images_dir            = File.join 'app', 'assets', 'img'
javascripts_dir       = File.join 'app', 'assets', 'js'

preferred_syntax      = :scss

line_comments         = false
output_style          = :compact
