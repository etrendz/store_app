class SaleProductsController < ApplicationController
  before_filter :set_sale_product, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  # GET /sale_products
  # GET /sale_products.json
  def index
    @sale_products = SaleProduct.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sale_products }
    end
  end

  # GET /sale_products/1
  # GET /sale_products/1.json
  def show
  end

  # GET /sale_products/new
  # GET /sale_products/new.json
  def new
    @sale_product = SaleProduct.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sale_product }
    end
  end

  # GET /sale_products/1/edit
  def edit
		render :partial => 'form'
  end

  # POST /sale_products
  # POST /sale_products.json
  def create
    @sale_product = SaleProduct.new(sale_product_params)

    respond_to do |format|
      if @sale_product.save
        format.html { redirect_to @sale_product, notice: 'Sale product was successfully created.' }
        format.json { render json: @sale_product, status: :created, location: @sale_product }
      else
        format.html { render action: "new" }
        format.json { render json: @sale_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sale_products/1
  # PUT /sale_products/1.json
  def update
    respond_to do |format|
      if @sale_product.update_attributes(sale_product_params)
        format.html { redirect_to @sale_product.sale, notice: 'Sale product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sale_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale_products/1
  # DELETE /sale_products/1.json
  def destroy
    @sale_product.destroy

    respond_to do |format|
      format.html { redirect_to sale_products_url }
      format.json { head :no_content }
    end
  end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_product
      @sale_product = SaleProduct.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_product_params
      params.require(:sale_product).permit(:cprice, :price, :product_id, :qty, :sale_id)
    end
end
