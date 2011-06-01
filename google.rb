module Interpres
  module Google
    class Document
      URLS = {
        :auth     => 'https://www.google.com/accounts/ClientLogin',
        :retrieve => 'https://docs.google.com/feeds/default/private/full/',
        :download => 'https://docs.google.com/feeds/download/documents/export/Export'
      }
      
      HEADERS = {
        :version      => '3.0',
        :content_type => 'application/x-www-form-urlencoded'
      }
      
      def initialize(href)
        determine_resource_from href
        
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
      
      def determine_resource_from(href)
        @resource_id = href
        @resource_type = href
      end
      
      def request_token
        response = Nestful.send(:post, URLS[:auth], :headers => @@headers, :params => @@auth_params)
        response.strip.to_a.last.split("=").last
      end
      
      def retrieve(id)
        url = URLS[:retrieve] + id
        params = { 'alt' => 'json' }
        response = Nestful.send(:get, url, :headers => @@headers, :params => params)
        resource = JSON.parse(@resource_type == 'document' ? response['entry'] : response['feed']['entry'][0])
        output = {
          :user_name      => resource['author'].first['name']['$t'],
          :user_email     => resource['author'].first['email']['$t'],
          :resource_id    => @resource_id,
          :resource_type  => @resource_type,
          :resource_title => resource['title']['$t'],
          :resource_lang  => resource['link'][1]['href'].split("hl=").last.gsub(/\_.*/, "")
        }
      end
      
      #def download(id)
      #end
      
    end    
  end
end