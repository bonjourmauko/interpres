require 'yajl/json_gem'
require 'sinatra/activerecord'
require 'models/email'
require 'sendgrid'

module Interpres  
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
    
    get '/emails' do
      Email.all.to_json
    end
    
    get '/emails/:id' do
      begin
        Email.find(params[:id]).to_json
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    post '/emails' do
      status 200, 'success'
      #begin
      #  req = Interpres::Sendgrid::ParseApi.new params
      #  Email.create!(:from => req.from, :href => req.href).to_json
      #rescue => e
      #  HoptoadNotifier.notify e
      #  error 500, e.message.to_json
      #end
    end
        
  end
end