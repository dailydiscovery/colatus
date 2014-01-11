xml.instruct!
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Daily Discovery Pull Requests From #{@login}"
    xml.description "Daily Discovery Pull Requests From #{@login}"
    xml.link "http://dailydiscovery.herokuapp.com/#{@login}/pulls.rss"

    @items.each do |item|
      xml.item do
        xml.link item[:link]
        xml.title do
          xml.cdata! item[:title]
        end
        xml.description do
          xml.cdata! item[:description]
        end
        xml.pubDate Time.parse(item[:pub_date]).rfc822
        xml.guid item[:link]
      end
    end
  end
end
