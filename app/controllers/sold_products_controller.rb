class SoldProductsController < ApplicationController
  before_filter :sold_product, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  # GET /sold_products
  # GET /sold_products.json
  def index
    @sold_products = SoldProduct.all
  end

  # GET /sold_products/1
  # GET /sold_products/1.json
  def show
  end

  # GET /sold_products/new
  # GET /sold_products/new.json
  def new
    @sold_product = SoldProduct.new
  end

  # GET /sold_products/1/edit
  def edit
  end

  # POST /sold_products
  # POST /sold_products.json
  def create
    @sold_product = SoldProduct.new(sold_product_params)

    respond_to do |format|
      if @sold_product.save
        format.html { redirect_to @sold_product, notice: 'Sold product was successfully created.' }
        format.json { render json: @sold_product, status: :created, location: @sold_product }
      else
        format.html { render action: "new" }
        format.json { render json: @sold_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sold_products/1
  # PUT /sold_products/1.json
  def update
    respond_to do |format|
      if @sold_product.update_attributes(sold_product_params)
        format.html { redirect_to @sold_product, notice: 'Sold product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sold_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sold_products/1
  # DELETE /sold_products/1.json
  def destroy
    @sold_product.destroy

    respond_to do |format|
      format.html { redirect_to sold_products_url }
      format.json { head :no_content }
    end
  end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sold_product
      @sold_product = SoldProduct.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sold_product_params
      params.require(:sold_product).permit(:cprice, :price, :product_id, :purchase_product_id, :sale_product_id, :stock_product_id)
    end
end
