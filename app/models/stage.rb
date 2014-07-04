# encoding: utf-8
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
    "#{((created_at.to_date - item.on_sale_date).to_i + 1)}.#{self.created_at.hour}"
  end

  def saled_today
    # 如果当天刚上线
    if self.item.on_sale_date == self.created_at.to_date
      self.sum

    # 如果已经上线数天，找到前一天的最后一个tag
    else
      last_stage_tag = self.item.latest_tag_stage_before(self.created_at.to_date)
      if last_stage_tag
        self.sum - last_stage_tag.sum
      else
        self.sum
      end
    end
  end
end
