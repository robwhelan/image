class ProductsController < ApplicationController
  include ImageGather
  def show_products
    apparel = "shirts"
    color = "navy blue"
    hex = "#000080"
    
    if params[:apparel] && params[:color] && params[:hex]
      @apparel = params[:apparel]
      @color = params[:color]
      @hex = params[:hex]
    end
    
    @products = search_for_products(@apparel, @color, @hex)
    #@products = @item_info
  end
end
