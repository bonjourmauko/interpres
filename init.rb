require 'yajl/json_gem'
require 'sinatra/activerecord'
require 'models/email'

module SendgridParse  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'
      databases = YAML.load_file('config/database.yml')
      ActiveRecord::Base.establish_connection(databases[env])
    end
    
    post '/emails' do 
      begin
        string = ""
        request.body.each do |var|
          string += var.to_s
        end
        Email.create!( :body => string )
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    get '/emails' do
      @emails = Email.all
      haml :emails
    end

  end
end