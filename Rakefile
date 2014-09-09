$LOAD_PATH << File.dirname(__FILE__)

require 'app'
require 'sinatra/activerecord/rake'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:quality) do |task|
  task.fail_on_error = false
end

task default: :quality
