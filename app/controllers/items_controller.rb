# encoding: utf-8
class ItemsController < ApplicationController
  def index
    @items = Item.includes(:stages).all
  end

  def new
    @item = Item.new params.permit(:uri)
    
    if @item.uri.present?
      begin
        doc = Nokogiri::HTML HTTParty.get(@item.uri, timeout: 10).body   
      rescue Exception => e
        doc = nil
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
        
        @item.name  = name
        @item.code  = code
        @item.price = price
        @item.image_uri = doc.css(".art_area img").first.attr("src")
      else
        @item.uri = "有问题！"
      end
    end
  end

  def create
    @item = Item.new params.require(:item).permit(:uri, :name, :code, :price, :image_uri, :on_sale_date, :off_sale_date) 
    if @item.save
      flash[:notice] = '添加完成'
      redirect_to root_path
    else
      flash[:alert]  = '添加失败'
      render :new
    end
  end

  def refresh
    if params[:from] && params[:from] == "index"
      @item = Item.find(params[:id])
      @item.refresh_current_stage
      redirect_to items_path
    else
      render :show
    end
  end
end