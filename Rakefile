require 'init'
require 'sinatra/activerecord/rake'

task :environment do
  env = ENV['SINATRA_ENV'] || 'development'
  databases = YAML.load_file('config/database.yml')
  ActiveRecord::Base.establish_connection(databases[env])
end