require 'tempfile'
require 'yajl/json_gem'
require 'sinatra/activerecord'
require 'models/resource'
require 'sendgrid'
require 'google'
require 'tapir'
require 'storage'

module Interpres  
  class Init < Sinatra::Base
    
    configure do
      env = ENV['SINATRA_ENV'] || 'development'
      databases = YAML.load_file('config/database.yml')
      ActiveRecord::Base.establish_connection(databases[env])
    #  class << Sinatra::Base
    #    def http_options path,opts={}, &blk
    #      route 'OPTIONS', path, opts, &blk
    #    end
    #  end
    #  Sinatra::Delegator.delegate :options
    #  options /.+/ do
    #    response['Access-Control-Allow-Origin'] = '*'
    #    response['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS' 
    #  end
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
    
    #get '/resources/folders/:resource_id/contents' do
    #  begin
    #    response = Interpres::Google::Folder.new.contents(params[:resource_id]).to_json
    #    callback = params.delete('callback')
    #    if callback
    #      content_type :js
    #      "#{callback}(#{response})" 
    #    else
    #      response  
    #    end
    #  rescue => e
    #    HoptoadNotifier.notify e
    #    error 500, e.message.to_json
    #  end
    #end
    
    get '/resources/books/premaster/:premaster_id' do
      begin
        response = Interpres::Storage::Download.new.premaster(params[:premaster_id]).to_json
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
        response = Interpres::Sendgrid::ParseEmail.new params
        Resource.create!(:resource_id => response.resource_id)
        Interpres::Tapir.send_source(Interpres::Google::Resource.new.retrieve(response.resource_id)).to_json
      rescue => e
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
    
    post '/resources/books/premaster' do
      begin
        Interpres::Storage::Upload.new.premaster(params[:premaster_id], params[:body])
      rescue => e
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
    
    post '/assets/image/transload' do
      begin
        file = Interpres::Storage::Download.new.image(params[:original_url])
        Interpres::Storage::Upload.new.image(params[:container], params[:path], file).to_json
      rescue => e
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
        
  end
end