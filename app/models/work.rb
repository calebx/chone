class Work
  def self.start
    puts "#{Time.now} work start ..."
    Item.all.each do |i|
      i.tag_stage
    end
    puts "--- Done."
  end
end