class Work
  def self.start
    Item.all.each do |i|
      i.tag_stage
    end
  end
end