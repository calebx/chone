# encoding: utf-8
class Item < ActiveRecord::Base
  include ItemHttpRequest

  validates :uri,   presence: true
  validates :price, presence: true

  scope :live,     -> { where(archive: false) }
  scope :archived, -> { where(archive: true) }

  has_many :stages
  has_many :tag_stages,    -> { where(category: Stage.categories[:tag])},    class_name: "Stage"
  has_many :random_stages, -> { where(category: Stage.categories[:random])}, class_name: "Stage"
  
  def latest_tag_stage
    tag_stages.order(:created_at).last
  end

  def first_tag_stage
    tag_stages.order(:created_at).first
  end

  def first_day_tag_stage
    latest_tag_stage_at(self.on_sale_date)
  end

  def latest_tag_stage_at(a_date)
    latest_tag_stage_before(a_date + 1)
  end

  def latest_tag_stage_before(a_date)
    tag_stages.where("created_at < ?", a_date.try(:to_time)).order(:created_at).last
  end

  def latest_random_stage
    random_stages.order(:created_at).last
  end

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

  def create_tag_stage
    self.tag_stages.create
  end

  def create_random_stage
    self.random_stages.create
  end

  def hourly_tag_stage
    return nil if (self.pre_sale? || self.off_sale?)
    return nil if (Time.now.hour <= 9 && self.first_day?)
    return self.create_tag_stage
  end

  def refresh_random_stage
    if self.latest_random_stage && (Time.now - self.latest_random_stage.created_at) <= 10
      self.latest_random_stage
    else
      self.create_random_stage
    end
  end

  after_create :refresh_random_stage

  def archive!
    self.update(archive: true)
  end

  def unarchive!
    self.update(archive: false)
  end
end
