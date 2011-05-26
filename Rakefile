require 'init'
require 'sinatra/activerecord/rake'
require 'hoptoad_notifier'


task :environment do
  env = ENV['SINATRA_ENV'] || 'development'
  databases = YAML.load_file('config/database.yml')
  ActiveRecord::Base.establish_connection(databases[env])
end

namespace :db do
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true 
    ActiveRecord::Migrator.migrate("db/migrate")
  end 
end