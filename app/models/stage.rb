class Stage < ActiveRecord::Base
  belongs_to :item

  enum category: { tag: 0, random: 1 }
  enum status:   { ok: 0, short: 1, long: 2 }

  before_save :calc

  def list
    self.content ? JSON.parse(self.content) : []
  end

  def calc
    self.content = self.item.fetch_api_current_content
    self.sum     = list.sum{|i| i["saled"]} if self.list
  end

  def code
    "#{((Date.today - created_at.to_date).to_i + 1)}.#{self.created_at.hour}"
  end
end
