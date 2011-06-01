module Interpres
  module Sendgrid
    class ParseEmail
      
      ## Possible params | source: http://wiki.sendgrid.com/doku.php?id=parse_api
      # text          Text body of email. If not set, email did not have a text body.
      # html          HTML body of email. If not set, email did not have an HTML body.
      # from          Email sender, as taken from the message headers
      # to            Email recipient field, as taken from the message headers
      # cc            Email cc field, as taken from the message headers
      # subject       Email Subject.
      # dkim          A JSON string containing the verification results of any dkim and domain keys signatures in the message.
      # SPF           The results of Sender Policy Framework verification of the message sender and receiving IP address
      # envelope      A JSON string containing the SMTP envelope. This will have two variables: to, which is an array of 
      # =>            recipients, and from, which is the return path for the message
      # charsets      A JSON string containing the character sets of the fields extracted from the message
      # spam_score    Spam Assassin's rating for whether or not this is spam.
      # spam_report   Spam Assassin's spam report.
      # attachments   Number of attachments included in email.
      # attachmentN   File upload names. The numbers are sequence numbers starting from 1 and ending on the number 
      #               specified by the attachments parameter. If attachments is 0, there will be no attachment files. 
      #               If attachments is 3, parameters attachment1, attachment2, and attachment3 will have file uploads.
      #               TNEF files (winmail.dat) will be extracted and have any attachments posted.

      def initialize(params)
        params.each do |key, value|
          key = key.dup.gsub(/[^a-z0-9]+/i, '_').downcase
          instance_variable_set("@#{key}", "#{value}")
          ParseEmail.define_accessor(key, value)
        end
      end
    
      def self.define_accessor(key, value)
        define_method(key) { value }
      end
    
      # refactor
      def resource_id
        content = Nokogiri::HTML @html
        
        pene = []
        
        content.css('a').each do |a|
          #resource_id = a['href'].scan(/^.*[\/|\.|\?|\=]([a-z0-9\-\_]{44,})[\/|\&|\=].*$/i)
          #unless resource_id.empty?
          #  resource_id[0][0]
          #end
          pene << a['href']
        end
        pene = pene.to_s.scan(/^.*[\/|\.|\?|\=]([a-z0-9\-\_]{44,})[\/|\&|\=].*$/i)
        return pene.to_s unless pene.empty?
        return 'q wea'
        nil
      end
    
    end
  end
end