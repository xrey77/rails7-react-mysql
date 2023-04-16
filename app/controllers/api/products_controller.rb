class Api::ProductsController < ApplicationController

 def index
    @pg = params[:page]
    @products = Product.page(@pg)
    @totpages =  Product.page(1).total_pages
    print("Total Pages :", @totpages)
    render :json => {'totpages' => @totpages,'page' => @pg, 'products' => @products}
 end

 private

 def product_params
    params.require(:product).permit(:descriptions, :qty,  :unit, :cost_price, :sell_price, :prod_pic, :category, :sale_price, :alert_level, :critical_level)
end

end
