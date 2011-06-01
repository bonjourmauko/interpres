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
    
    
    #before do
    #  content_type :json
    #end
    
    #get '/emails' do
    #  Email.all.to_json
    #end
    
    #get '/emails/:id' do
    #  begin
    #    Email.find(params[:id]).to_json
    #  rescue => e
    #    error 500, e.message.to_json
    #  end
    #end
    
    get '/document/:id/download' do
      begin
        callback = params.delete('callback')
        if callback
          content_type :js
          return "#{callback}(#{params.json})" 
        else
          content_type :json
          return params.to_json
        end
      rescue => e
        content_type :json
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
    
    get '/collection/:id/contents' do
      begin
        content_type :json
        params.to_json
      rescue => e
        content_type :json
        HoptoadNotifier.notify e
        error 500, e.message.to_json
      end
    end
    
    #post '/emails' do
    #  begin
    #    req = Interpres::Sendgrid::ParseApi.new params
    #    #Email.create!(:from => req.from, :href => req.href).to_json
    #    resp = Interpress::Google::Document.new.retrieve(req.href).to_json
    #    Nestful.send(:post, "/path/to/tapir", :params => resp)
    #  rescue => e
    #    HoptoadNotifier.notify e
    #    error 500, e.message.to_json
    #  end
    #end
        
  end
end