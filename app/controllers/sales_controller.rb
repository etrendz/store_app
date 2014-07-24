class SalesController < ApplicationController
  before_filter :set_sale, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  # GET /sales
  # GET /sales.json
  def index
    @sales = Sale.includes({sale_products: :product}, :customer).order("sale_date DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sales }
    end
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
	@total_sales = @sale.sale_products.sum(:price)
	@discount = (@total_sales * (@sale.discount).to_i / 100)
	@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sale }
	  format.pdf do
		pdf = SalePdf.new(@sale, @total_sales)
		send_data pdf.render, filename: "sale_#{@sale.id}.pdf",
								type: "application/pdf",
								disposition: "inline"
	  end
    end
  end

  # GET /sales/new
  # GET /sales/new.json
  def new
		invoice = Sale.last ? Sale.last.invoice.next : 1
    @sale = Sale.new(:invoice => invoice)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sale }
    end
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render json: @sale, status: :created, location: @sale }
      else
        format.html { render action: "new" }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sales/1
  # PUT /sales/1.json
  def update

    respond_to do |format|
      if @sale.update_attributes(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to sales_url }
      format.json { head :no_content }
    end
  end

  def add_sale_products
	p "===========product_name============"
	p params[:product_name]
	@product = Product.find_by_name(params[:product_name])
	@qty = params[:qty] == '' ? 1 : params[:qty]
	@price = params[:price] == '' ? (@product.stock_products.last.price * @qty.to_i) : (params[:price].to_f * @qty.to_i)
	render :partial => 'sale_product', :locals => {:sale_product_object => SaleProduct.new(:product_id => @product.id, :qty => @qty, :price => @price)}
  end
	
  def receivables
    @sales = Sale.where(:paid => 0)
	end
	
  # PUT /sales/1
  # PUT /sales/1.json
  def receive_now
    @sale = Sale.find(params[:id])
	@sale.paid = 1
    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Payment was successfully Received.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def sale_report
	@from = Date.strptime(params[:from])
	@to = Date.strptime(params[:to])
    @sales = Sale.where(:sale_date  => @from..@to)
 #   @sales = @sales.where(:customer_id  => params[:customer])
		@total_sale = 0
	  render :partial => 'sale_report'
  end

  def customer_report
  end
	
  def sales_return
    @sale = Sale.find(params[:id])
	@total_sales = @sale.sale_products.sum(:price)
	@discount = (@total_sales * (@sale.discount).to_i / 100)
	@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
	end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:customer_id, :paid, :remark, :sale_date, :order, :dc, :invoice, :discount, :vat, :customer_name, new_sale_product_attributes: [:id, :sale_id, :cprice, :price, :product_id, :qty])
    end
end
