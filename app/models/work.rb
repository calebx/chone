class Work
  def self.start
    puts "#{Time.now} work start ..."
    Item.live.each do |i|
      i.hourly_tag_stage
    end
    puts "--- Done."
  end
end