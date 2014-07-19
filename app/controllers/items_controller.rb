# encoding: utf-8
class ItemsController < ApplicationController
  def index
    if params[:scope] == 'live'
      @items = Item.live.includes(:stages)
    elsif params[:scope] == 'archive'
      @items = Item.archived.includes(:stages)
    elsif params[:scope] == 'all'
      @items = Item.includes(:stages)
    else
      @items = Item.live.includes(:stages)
    end

    @items = @items.order('on_sale_date DESC')
  end

  def new
    @item = Item.new params.permit(:uri)
    @item.examine_web_content if @item.uri.present?
    flash[:alert] = "添加失败，请确定uri，价格都有写明确。"
  end

  def create
    @item = Item.new params.require(:item).permit(:uri, :name, :code, :price, :image_uri, :on_sale_date, :off_sale_date) 
    @item.examine_web_content if !@item.price
    if @item.save
      flash[:notice] = '添加完成'
      redirect_to root_path
    else
      flash[:alert]  = '添加失败，请确定uri，价格都有写明确。'
      render :new
    end
  end

  def show
    @item = Item.find params[:id]
  end

  def edit
    @item = Item.find params[:id]
  end

  def update
    @item = Item.find params[:id]
    @item.update params.require(:item).permit(:uri, :name, :code, :price, :image_uri, :on_sale_date, :off_sale_date) 
    redirect_to root_path
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

  def destroy
    @item = Item.find params[:id]
    if params[:archive].to_i == 1
      unless @item.archive
        @item.archive!
      else
        @item.unarchive!
      end
    else
      @item.destroy
    end
    redirect_to items_path
  end
end