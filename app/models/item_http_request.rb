# encoding: utf-8
module ItemHttpRequest
  # fetch api data content
  VIP_API_URI_BASE = "http://stock.vip.com/detail?callback=detail_stock&merchandiseId=%s"
  TIMEOUT_GAP      = 10
  
  def vip_id
    match = self.uri.match(/\-(\d*)\.html/)
    if match
      match[1]
    else
      nil
    end
  end

  def vip_api_uri
    VIP_API_URI_BASE % vip_id
  end

  def fetch_api_current_content
    body_str = ""
    begin
      body_str    = HTTParty.get(self.vip_api_uri, timeout: TIMEOUT_GAP).body
    rescue Exception => e
      puts e
    end
    content_str = body_str.gsub(/^detail_stock\({"items":/, "").gsub(/}\)$/, "")
    content_str
  end

  def examine_web_content
    if self.uri.present?
      doc = nil
      
      begin
        doc = Nokogiri::HTML HTTParty.get(self.uri, timeout: 10).body
      rescue Exception => e
        puts e
      end
      
      if doc
        name = doc.css(".shan_description strong").first.content
        code = nil
        doc.css(".shan_description p").each do |p|
          rst = p.content.match(/商品货号：?(.*)$/) 
          if rst
            code = rst[1] 
            break
          end
        end
        price = doc.css(".shan_info .shan_price strong").first.content.to_f
        image_uri = doc.css(".art_area img").first.attr("src")

        self.name  = name
        self.code  = code
        self.price = price
        self.image_uri = image_uri
      end
    end

    self
  end
end