require 'yajl/json_gem'
require 'sinatra/activerecord'
require 'models/email'
require 'sendgrid'
require 'google'

module Interpres  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'
      databases = YAML.load_file('config/database.yml')
      ActiveRecord::Base.establish_connection(databases[env])
    end
    
    mime_type :json, 'application/json'
    mime_type :js,   'text/javascript'
    
    
    before do
      content_type :json
    end
    
    get '/resources' do
      Resource.all.to_json
    end
    
    get '/resources/:id' do
      begin
        Resource.find(params[:id]).to_json
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    get '/resources/:resource_id' do
      begin
        Resource.find(params[:resource_id]).to_json
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    get '/resources/documents/:resource_id/download' do
      begin
        response = Interpres::Google::Document.new.download(params[:resource_id]).to_json
        callback = params.delete('callback')
        if callback
          content_type :js
          "#{callback}(#{response})" 
        else
          response  
        end
      rescue => e
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
    
    get '/resources/folders/:resource_id/contents' do
      begin
        response = Interpres::Google::Folder.new.contents(params[:resource_id]).to_json
        callback = params.delete('callback')
        if callback
          content_type :js
          "#{callback}(#{response})" 
        else
          response  
        end
      rescue => e
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
    
    post '/resources' do
      begin
        response = Interpres::Sendgrid::ParseApi.new params
        Resource.create!(:resource_id => response.resource_id).to_json
    #    resp = Interpress::Google::Document.new.retrieve(req.href).to_json
    #    Nestful.send(:post, "/path/to/tapir", :params => resp)
      rescue => e
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
        
  end
end