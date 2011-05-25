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
        body = {}
        @params = env['rack.request.form_vars']
        
        body[:text]         = @params["text"]                rescue nil
        body[:html]         = @params["html"]                rescue nil
        body[:from]         = @params["from"]                rescue nil
        body[:to]           = @params["to"]                  rescue nil
        body[:cc]           = @params["cc"]                  rescue nil
        body[:subject]      = @params["subject"]             rescue nil
        body[:dkim]         = JSON.parse @params["dkim"]     rescue nil
        body[:spf]          = @params["SPF"]                 rescue nil
        body[:envelope]     = JSON.parse @params["envelope"] rescue nil
        body[:charsets]     = JSON.parse @params["charsets"] rescue nil
        body[:spam_score]   = @params["spam_score"]          rescue nil
        body[:spam_report]  = @params["spam_report"]         rescue nil
        body[:attachments]  = @params["attachments"]         rescue nil
        
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