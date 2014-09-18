class PurchaseProductsController < ApplicationController
  before_filter :set_purchase_product, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  # GET /purchase_products
  # GET /purchase_products.json
  def index
    @purchase_products = PurchaseProduct.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_products }
    end
  end

  # GET /purchase_products/1
  # GET /purchase_products/1.json
  def show
  end

  # GET /purchase_products/new
  # GET /purchase_products/new.json
  def new
    @purchase_product = PurchaseProduct.new
  end

  # GET /purchase_products/1/edit
  def edit
		render :partial => 'form'
  end

  # POST /purchase_products
  # POST /purchase_products.json
  def create
    @purchase_product = PurchaseProduct.new(purchase_product_params)

    respond_to do |format|
      if @purchase_product.save
        format.html { redirect_to @purchase_product, notice: 'Purchase product was successfully created.' }
        format.json { render json: @purchase_product, status: :created, location: @purchase_product }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_products/1
  # PUT /purchase_products/1.json
  def update
    respond_to do |format|
      if @purchase_product.update_attributes(purchase_product_params)
        format.html { redirect_to @purchase_product.purchase, notice: 'Purchase product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_products/1
  # DELETE /purchase_products/1.json
  def destroy
    @purchase_product.destroy

    respond_to do |format|
      format.html { redirect_to purchase_products_url }
      format.json { head :no_content }
    end
  end
  
  def purchase_products_price
	 @purchase_products = PurchaseProduct.find_all_by_product_id(params[:id])
	 @purchase_product = @purchase_products.last
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase_product }
    end
  end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_product
      @purchase_product = PurchaseProduct.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_product_params
      params.require(:purchase_product).permit(:price, :cprice, :product_id, :purchase_id, :qty, :invoice_qty, :received_qty)
    end
end
