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
        href = params[:html].scan(/https\:\/\/docs.google.com\/[a-z]\/.*?\/document\/[a-z]\/.*?\/edit/) rescue nil
        email = Email.create!(:href => href.first) rescue nil
        return email.to_json if email
        error 400
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    get '/emails' do
      Email.all.to_json
    end
    
    get '/emails/:id' do
      begin
        email = Email.find(params[:id]) rescue nil
        return email.to_json if email
        error 404, {:email => {}}.to_json
      rescue => e
        error 500, e.message.to_json
      end
    end
        
  end
end