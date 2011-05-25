module SendgridParse
  class Wrapper
    
    attr_accessor :from,
                  :html
    
    def initalize(params)
      @from = params[:from]
      @html = params[:html]
    end
    
    def href
      content = Nokogiri::HTML @html
      content.css('a').each do |a|
        return a['href'] unless a['href'].scan("edit").empty?
      end
      nil
    end
    
  end
end