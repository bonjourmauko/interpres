module Interpres
  module Storage
    class Connection
      def initialize
        @@credentials ||= YAML.load_file('config/cloudfiles.yml')
        @connection = CloudFiles::Connection.new(:username => @@credentials['username'], :api_key => @@credentials['api_key'])
      end  
    end
    
    class Upload < Interpres::Storage::Connection
      def initialize
        super
      end
      
      def premaster(premaster_id, body)
        file = Tempfile.new premaster_id
        file << body
        file.flush
        
        container = @connection.container 'premaster'
        object = container.create_object "#{premaster_id}"
        object.write file
      end
      
      def image(container_, path, file)
        container = @connection.create_container "#{container_}"
        object = container.create_object "#{path}"
        object.write file
      end
    end
    
    class Download < Interpres::Storage::Connection
      def initialize
        super
      end
      
      def premaster(premaster_id)
        container = @connection.container 'premaster'
        object = container.object "#{premaster_id}"
        output = { :body => object.data }
      end
      
      def image(original_url)
        Nestful.send(:get, "#{original_url}", :buffer => true)
      end
    end
    
  end
end
