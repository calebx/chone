# encoding: utf-8
class ItemsController < ApplicationController
  def index
    @items = Item.includes(:stages).all
  end

  def new
    @item = Item.new params.permit(:uri)
    @item.examine_web_content if @item.uri.present?
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

  def show
    @item = Item.find params[:id]
  end

  def refresh
    @item = Item.find params[:id]
    @item.refresh_random_stage
    if params[:from] && params[:from] == "index"
      redirect_to items_path
    else
      redirect_to item_path
    end
  end
end