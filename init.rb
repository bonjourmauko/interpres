module SendgridParse
  class Init < Sinatra::Base
  
    post '/' do 
      "Hi" 
    end
    
    get '/email_list' do
      "Hello"
    end

  end
end