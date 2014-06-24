class Stage < ActiveRecord::Base
  belongs_to :item

  before_save :calc

  def list
    if self.content
      JSON.parse(self.content)
    else
      []
    end
  end

  def calc
    self.content = self.item.fetch_api_current_content
    self.sum     = list.sum{|i| i["saled"]} if self.list
  end

  def refresh
    if (Time.now - self.updated_at) >= 10.0
      puts "refreshing..."
      self.save
    end
  end
end
