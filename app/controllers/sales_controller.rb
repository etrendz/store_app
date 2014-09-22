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
	@total_returns = @sale.sale_returns.sum(:price)
	@discount = (@total_sales * (@sale.discount).to_f / 100)
	@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
    respond_to do |format|
     format.html # show.html.erb
      format.json { render json: @sale }
	  format.pdf do
		pdf = SalePdf.new(@sale, @total_sales, @total_returns)
		pdf.print
		send_data pdf.render, filename: "sale_#{@sale.id}.pdf",
								type: "application/pdf", disposition: "inline"
	  end
    end
  end

  # GET /sales/new
  # GET /sales/new.json
  def new
		sale = Sale.where("sale_type like ?", "CB%").last
		invoice = sale ? sale.invoice.next : "CB - 1"
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
	last_sale = Sale.find_by_invoice(@sale.invoice)
	@sale.invoice = last_sale.invoice.next if last_sale
    respond_to do |format|
      if @sale.save			
=begin
				error = ''		
				message = "Thanks for purchase"
				encoded_message = URI.encode(message)
				if @sale.customer
					cur_request = "http://hpsms.dial4sms.com/api/web2sms.php?username=prestn&password=happy@1234&sender=PRESTN&message=#{encoded_message}&workingkey=1151220r79wiay6enz95&to=#{@sale.customer.mobile}"
					begin
						response = Net::HTTP.get_response(URI.parse(cur_request))
					rescue Timeout::Error => e
						p e.message + " Timeout"
						error = e
					rescue Errno::ECONNREFUSED => e
						p e.message + " Refused"
						error = e
					rescue SocketError => e
						puts e.message
						error = e
					end
				end
=end	
         format.html { redirect_to "/sales/#{@sale.id}.pdf", notice: "Sale was successfully created." }
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
	@product = Product.find_by_code(params[:product_code])
	@qty = params[:qty] == '' ? 1 : params[:qty]
	@price = params[:price] == '' ? (@product.stock_products.last.price * @qty.to_i) : (params[:price].to_f * @qty.to_i)
	render :partial => 'sale_product', :locals => {:sale_product_object => SaleProduct.new(:product_id => @product.id, :qty => @qty, :price => @price)}
  end
	
  def add_sale_returns
	@product = Product.find_by_code(params[:product_code])
	@qty = params[:qty] == '' ? 1 : params[:qty].to_i
	@price = params[:price] == '' ? (@product.stock_products.last.price * @qty.to_i) : (params[:price].to_f * @qty.to_i)
	render :partial => 'sale_return', :locals => {:sale_return_object => SaleReturn.new(:product_id => @product.id, :qty => @qty, :price => @price, :cprice => (@product.cprice.to_i * @qty))}
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
				client = Twilio::REST::Client.new(TWILIO_CONFIG['sid'], TWILIO_CONFIG['token'])
				
				# Create and send an SMS message
				client.account.sms.messages.create(
					from: TWILIO_CONFIG['from'],
					to: '+919791079821',
					body: "Thanks for purchasing."
				)
				p "============Msg Sent =============="
				
        format.html { redirect_to @sale, notice: 'Payment was successfully Received.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end
=begin
  def sale_report
	@from = Date.strptime(params[:from])
	@to = Date.strptime(params[:to])
    @sales = Sale.where(:sale_date  => @from..@to)
 #   @sales = @sales.where(:customer_id  => params[:customer])
		@total_sale = 0
	  render :partial => 'sale_report'
  end


	def sale_report
		@opening_stock = Hash.new
		@sale_stock = Hash.new
		
		@total_stock_price = 0
	#	@products = Product.includes({sale_products: :sale})
		@products = Product.all
		p "==============="
		p @products
		
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
		@products.each do |product|
				@opening_stock[product.id] = product.opening(@from)
				@sale_stock[product.id] = product.sale_on_date_range(@from, @to)
		end
	  render :partial => 'sale_report'
	
	end

=end

	def sale_report
	
		@total_sale = 0
		@total_cb_sale = 0
		@total_cd_sale = 0
		
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
    @sales = Sale.includes({sale_products: :product}).where(:sale_date  => @from..@to)
		unless params[:report_type] == "ALL"
			@sales = @sales.where("invoice like ?", "#{params[:report_type][0..1]}%") 
		else
			@cb_sales = @sales.where("invoice like ?", "CB%")
			@cb_sales.each do |sale| 
				total_sales = sale.sale_products.sum(:price)
				discount = (total_sales * (sale.discount).to_f / 100)
				@total_cb_sale += (total_sales - sale.sale_returns.sum(:price) - discount)  	
			end
			
			@cd_sales = @sales.where("invoice like ?", "CD%")
			@cd_sales.each do |sale| 
				total_sales = sale.sale_products.sum(:price)
				discount = (total_sales * (sale.discount).to_f / 100)
				@total_cd_sale += (total_sales - sale.sale_returns.sum(:price) - discount)  		
			end
		end
	  render :partial => 'sale_report'
	
  end
  
  def day_sales_report
  end
	
  def day_sales
  end
  
  def customer_report
  end
	
  def sales_return
    @sale = Sale.find(params[:id])
	@total_sales = @sale.sale_products.sum(:price)
	@discount = (@total_sales * (@sale.discount).to_f / 100)
	@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
	end
	
  def sales_exchange
    @sale = Sale.find(params[:id])
		@total_sales = @sale.sale_products.sum(:price)
		@discount = (@total_sales * (@sale.discount).to_i / 100)
		@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
	end
	
	def last_od
		sale_type = params[:id]
		sale = Sale.where("sale_type like ?", "#{sale_type}%").last
		@invoice = sale ? sale.invoice.next : "#{sale_type[0..1]} - 1"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice.to_json }
    end
	end
	
	def search
	end
	
	def search_result
		@sale = Sale.find_by_invoice(params[:term])
		unless @sale.nil?
			@total_sales = @sale.sale_products.sum(:price)
			@discount = (@total_sales * (@sale.discount).to_i / 100)
			@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
			respond_to do |format|
        format.html { render action: "show",  :notice => "Sale fouund." }
				format.json { render json: @sale }
			end
		else
        redirect_to '/sales/search', notice: 'Sale could not be fouund.' 
		end
	end
	
	def sale_return
		@sale = Sale.find(params[:sale])
		@sale.sale_products.each do |sp|
			if params["check_#{sp.id}".to_sym] == 'on'
				@sale.sale_returns.create(:product_id => sp.product_id, :cprice => sp.cprice, :price => sp.price, :qty => sp.qty )
			end
		end
		redirect_to @sale, notice: 'Sales Return was successfully done.' 
	end

	def detailed_report
	end
	
	def detailed_day_sales
		@total_sale = 0
		@total_cb_sale = 0
		@total_cd_sale = 0
		
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
    @sales = Sale.includes({sale_products: :product}).where(:sale_date  => @from..@to)
		unless params[:report_type] == "ALL"
			@sales = @sales.where("invoice like ?", "#{params[:report_type][0..1]}%") 
		else
			@cb_sales = @sales.where("invoice like ?", "CB%")
			@cb_sales.each do |sale| 
				total_sales = sale.sale_products.sum(:price)
				discount = (total_sales * (sale.discount).to_f / 100)
				@total_cb_sale += (total_sales - sale.sale_returns.sum(:price) - discount)  	
			end
			
			@cd_sales = @sales.where("invoice like ?", "CD%")
			@cd_sales.each do |sale| 
				total_sales = sale.sale_products.sum(:price)
				discount = (total_sales * (sale.discount).to_f / 100)
				@total_cd_sale += (total_sales - sale.sale_returns.sum(:price) - discount)  		
			end
		end
	  render :partial => 'detailed_day_sales'
	
	end

	def sales_register
    if (params[:from].present? && params[:to].present?)
			
			@from = Date.strptime(params[:from])
			@to = Date.strptime(params[:to])
			@sales = Sale.includes({sale_products: :product}).where(:sale_date  => @from..@to)
			@cb_sale = Hash.new
			@cd_sale = Hash.new
			@total_cb_sale = 0
			@total_cd_sale = 0
			@total_sale = Hash.new
			@total_return = 0
			@return_on_date = Hash.new
			for mydate in @from..@to
				cb_sales = @sales.where(:sale_date  => mydate, :sale_type => 'CBP')
				total_sale = 0
				cb_sales.each do |sale|
					ts = sale.sale_products.sum(:price)
					discount = (ts * (sale.discount).to_f / 100)
					total_sale += ts - discount
				end
				@total_cb_sale += total_sale
				@cb_sale[mydate] = total_sale.round(2)
				cd_sales = @sales.where(:sale_date  => mydate, :sale_type => 'CDP')
				total_sale = 0
				cd_sales.each do |sale|
					ts = sale.sale_products.sum(:price)
					discount = (ts * (sale.discount).to_f / 100)
					total_sale += ts - discount
				end
				@total_cd_sale += total_sale
				@cd_sale[mydate] = total_sale.round(2)
				
				@total_sale[mydate] = (@cb_sale[mydate] + @cd_sale[mydate]) unless (@cb_sale[mydate] + @cd_sale[mydate]).zero?
			end
			
			respond_to do |format|
				if params[:report_type] == 'CB'
					format.html { render :partial => 'cb_sales_register' }
					format.pdf do
						pdf = CbSalesRegisterPdf.new(@from, @to, @total_sale, @total_cb_sale, @cb_sale)
						send_data pdf.render, filename: "cb_sales_register_for_#{@from}_#{@to}.pdf", type: "application/pdf", disposition: "inline"
					end
				else
					format.html { render :partial => 'sales_register' }
	#				format.json { render json: @sales }
					format.pdf do
						pdf = SalesRegisterPdf.new(@from, @to, @total_sale, @total_cb_sale, @total_cd_sale, @cb_sale, @cd_sale)
						send_data pdf.render, filename: "sales_register_for_#{@from}_#{@to}.pdf", type: "application/pdf", disposition: "inline"
					end
				end
			end
			
		end
	end
		
	def sales_return_register
    if (params[:from].present? && params[:to].present?)
			
			@from = Date.strptime(params[:from])
			@to = Date.strptime(params[:to])
			@sales = Sale.includes({sale_returns: :product}).where(:sale_date  => @from..@to)
			@return = Hash.new
			for mydate in @from..@to
				sales = @sales.where(:sale_date  => mydate)
				total_sale = 0
				sales.each do |sale|
					sr = sale.sale_returns.sum(:price)
					total_sale += sr
				end
				@return[mydate] = total_sale.round(2) unless total_sale.zero?
			end
			render :partial => 'sales_return_register'
		end
	end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:customer_id, :paid, :remark, :sale_type, :sale_date, :order, :dc, :invoice, :discount, :vat, :customer_name, new_sale_product_attributes: [:id, :sale_id, :cprice, :price, :product_id, :qty], new_sale_return_attributes: [:id, :sale_id, :cprice, :price, :product_id, :qty])
    end
end
