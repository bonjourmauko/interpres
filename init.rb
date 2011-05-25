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
    
    post '/emails' do
      begin
        if params[:from] && params[:to] && params[:subject] && params[:html]
          html = Nokogiri::HTML params[:html]
          html.css("a").each do |a|
            if a.content.scan(/https\:\/\/docs.google.com\/[a-z]\/.*?\/document\/[a-z]\/.*?\/edit/)
              @email = Email.create!(:body => {
                :from     => params[:from],
                :to       => params[:to],
                :subject  => params[:subject],
                :href     => a['href']
              })
              return
            end
          end
        else
          error 400
        end
      rescue => e
        error 500, e.message.to_json
      end
    end
    
    get '/emails' do
      @emails = Email.all
      haml :emails
    end
    
    #get '/emails/:id' do
    #  content_type :json
    #  @email = Email.find(params[:id])
    #  @email.to_json
    #end
    
  end
end