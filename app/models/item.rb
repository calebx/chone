class Item < ActiveRecord::Base
  include ItemHttpRequest
  has_many :stages
  
  def latest_tag_stage
    stages.where("code != ?", "0.0").order("created_at").last
  end

  def first_1_stage
    stages.where(code: "1.10").last
  end

  def first_2_stage
    stages.where(code: "1.11").last
  end

  def first_3_stage
    stages.where(code: "1.12").last
  end

  # new item or aged item
  def pre_sale?
    on_sale_date > Date.today
  end

  def on_sale?
    on_sale_date <= Date.today && off_sale_date > Date.today
  end

  def off_sale?
    off_sale_date <= Date.today
  end

  def first_day?
    on_sale_date == Date.today
  end

  after_initialize :build_sale_date
  def build_sale_date
    if on_sale_date.nil?
      self.on_sale_date  = Date.today + 1
    end

    if off_sale_date.nil?
      self.off_sale_date = Date.today + 9
    end
  end

  # ===== ===== ===== ===== ===== 
  def current_stage
    stage = self.stages.find_or_create_by(code: "0.0")
  end

  def tag_stage
    return nil if self.pre_sale? || self.off_sale?

    days  = (Date.today - self.on_sale_date + 1).to_i
    hours = Time.now.hour
    stage_code  = "#{days}.#{hours}"
    
    puts stage_code  

    if Time.now.hour <= 9
      self.stages.find_or_create_by(code: stage_code) if !self.first_day?
      puts 1
    elsif (10 <= Time.now.hour) && (Time.now.hour <= 11)
      self.stages.find_or_create_by(code: stage_code) if self.first_day?
      puts 2
    else
      self.stages.find_or_create_by(code: stage_code)
      puts 3
    end
  end

  def refresh_current_stage
    self.current_stage.refresh
  end
end