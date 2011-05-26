module Interpres
  module Sendgrid
    class ParseApi
      
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

      def initalize(params)
        params.each do |key, value|
          instance_variable_set("@#{key}", "#{value}")
          ParseApi.define_param key
        end
      end
    
      def self.define_param(key)
        define_method(key) { "@#{key}" }
      end
    
      # refactor
      def href
        content = Nokogiri::HTML @html
        content.css('a').each do |a|
          return a['href'] unless a['href'].scan("edit").empty?
        end
        nil
      end
    
    end
  end
end