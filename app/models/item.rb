class Item < ActiveRecord::Base
  has_many :stages

  VIP_API_URI_BASE = "http://stock.vip.com/detail?callback=detail_stock&merchandiseId=%s"

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
    body_str    = HTTParty.get(self.vip_api_uri).body
    content_str = body_str.gsub(/^detail_stock\({"items":/, "").gsub(/}\)$/, "")
  end

  def current_stage
    stage = self.stages.find_or_create_by(code: "0.0")
  end
end