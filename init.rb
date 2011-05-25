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
    
    #post '/emails' do 
    #  begin
    #    Email.create!( :body => env['request.form_vars'] )
    #  rescue => e
    #    error 500, e.message.to_json
    #  end
    #end
    
    post '/emails' do
      begin
        body = { :html => params[:html] }
        #params = request.params
        #params.each do |key, value|
        #  eval "body[:#{key}] = #{value}"
        #end
        Email.create!(:body => body)
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