class StockProductsController < ApplicationController
  before_filter :set_stock_product, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  # GET /stock_products
  # GET /stock_products.json
  def index
    @stock_products = StockProduct.all
  end

  # GET /stock_products/1
  # GET /stock_products/1.json
  def show
  end

  # GET /stock_products/new
  # GET /stock_products/new.json
  def new
    @stock_product = StockProduct.new
  end

  # GET /stock_products/1/edit
  def edit
  end

  # POST /stock_products
  # POST /stock_products.json
  def create
    @stock_product = StockProduct.new(stock_product_params)

    respond_to do |format|
      if @stock_product.save
        format.html { redirect_to @stock_product, notice: 'Stock product was successfully created.' }
        format.json { render json: @stock_product, status: :created, location: @stock_product }
      else
        format.html { render action: "new" }
        format.json { render json: @stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stock_products/1
  # PUT /stock_products/1.json
  def update
    respond_to do |format|
      if @stock_product.update_attributes(stock_product_params)
        format.html { redirect_to @stock_product, notice: 'Stock product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @stock_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_products/1
  # DELETE /stock_products/1.json
  def destroy
    @stock_product.destroy

    respond_to do |format|
      format.html { redirect_to stock_products_url }
      format.json { head :no_content }
    end
  end
  
  def stock_products_price
    @stock_products = StockProduct.where(:product_id => params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stock_products.first }
    end
  end
  
#  def latest_stock_products
 #   @stock_products = StockProduct.where(:product_id => params[:id])

  #  respond_to do |format|
  #    format.html # show.html.erb
 #     format.json { render json: @stock_products.last }
#    end 
#  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_product
      @stock_product = StockProduct.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_product_params
      params.require(:stock_product).permit(:price, :cprice, :product_id, :purchase_product_id, :sale_product_id, :qty)
    end
end
