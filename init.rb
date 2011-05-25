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
    
    mime_type :json, 'application/json'
    
    before do
      content_type :json
    end
    
    post '/emails' do
      begin
        href = params[:html].scan(/https\:\/\/docs.google.com\/[a-z]\/.*?\/document\/[a-z]\/.*?\/edit/)
        if href
          @email = Email.create!( :href => href.first )
        else
          error 400
        end
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    get '/emails' do
      Email.all.to_json
    end
    
    get '/emails/:id' do
      begin
        @email = Email.find(params[:id])
        if @email
          @email.to_json
        else
          error 404
        end
      rescue => e
        error 500, e.message.to_json
      end
    end
        
  end
end