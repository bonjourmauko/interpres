module Interpres
  module Tapir
  
    def self.send_source(params)
      Nestful.send(:post, "http://tapir.heroku.com/sources", :params => params)
    end
    
  end
end