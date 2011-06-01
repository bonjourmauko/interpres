module Interpres
  module Google
    class Resource
      BASE_URLS = {
        :auth     => 'https://www.google.com/accounts/ClientLogin',
        :retrieve => 'https://docs.google.com/feeds/default/private/full/',
        :download => 'https://docs.google.com/feeds/download/documents/export/Export'
      }
      
      HEADERS = {
        :version      => '3.0',
        :content_type => 'application/x-www-form-urlencoded'
      }
      
      def initialize        
        @@credentials ||= YAML.load_file('config/google_auth.yml')['client_login']
        @@auth_params ||= {
          'Email'       => @@credentials['email'],
          'Passwd'      => @@credentials['password'],
          'source'      => @@credentials['source'],
          'service'     => @@credentials['service'],
          'accountType' => @@credentials['account_type']
        }
        
        @@headers ||= {
            'GData-Version' => HEADERS[:version],
            'Content-type'  => HEADERS[:content_type]
        }        
        
        @token = request_token
        @@headers['Authorization'] = "GoogleLogin auth=#{@token}"
      end
            
      def request_token
        response = Nestful.send(:post, BASE_URLS[:auth], :headers => @@headers, :params => @@auth_params)
        response.strip.to_a.last.split("=").last
      end
      
      #def retrieve(id)
      #  url = URLS[:retrieve] + id
      #  params = { 'alt' => 'json' }
      #  response = Nestful.send(:get, url, :headers => @@headers, :params => params)
      #  resource = JSON.parse(@resource_type == 'document' ? response['entry'] : response['feed']['entry'][0])
      #  output = {
      #    :user_name      => resource['author'].first['name']['$t'],
      #    :user_email     => resource['author'].first['email']['$t'],
      #    :resource_id    => @resource_id,
      #    :resource_type  => @resource_type,
      #    :resource_title => resource['title']['$t'],
      #    :resource_lang  => resource['link'][1]['href'].split("hl=").last.gsub(/\_.*/, "")
      #  }
      #end
    end
    
    class Document < Interpres::Google::Resource
      def initialize
        super
      end
      
      def download(resource_id)
        params = { 'id' => resource_id, 'exportFormat' => 'html' }
        html = Nestful.send(:get, BASE_URLS[:download], :headers => @@headers, :params => params).to_s
        output = {
          :title  => html.scan(/<title.*?>(.*)<\/title>/)[0][0],
          :style  => html.scan(/<style.*?>(.*)<\/style>/)[0][0],
          :body   => html.scan(/<body.*?>(.*)<\/body>/)[0][0]
        }
      end
      
    end    
  end
end