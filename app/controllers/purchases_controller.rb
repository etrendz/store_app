class PurchasesController < ApplicationController
  before_filter :set_purchase, only: [:show, :edit, :update, :destroy, :purchase_return, :pay_now]
  before_filter :require_login
  # GET /purchases
  # GET /purchases.json
#  layout 'user_layout'
  def index
    @purchases = Purchase.includes({purchase_products: :product}, :supplier).order("purchase_date DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchases }
    end
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
		@total_purchase = 0
		@purchase.purchase_products.each { |pp| @total_purchase += pp.qty * pp.cprice }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
	  format.pdf do
		pdf = PurchasePdf.new(@purchase, @total_purchase)
		send_data pdf.render, filename: "purchase_#{@purchase.id}.pdf",
								type: "application/pdf",
								disposition: "inline"
	  end
    end
  end

  # GET /purchases/new
  # GET /purchases/new.json
  def new
#		invoice = Purchase.last ? Purchase.last.invoice.next : "CB - 1"
		purchase = Purchase.where("receipt_type like ?", "CB%").last
		invoice = purchase ? purchase.invoice.next : "CB - 1"
    @purchase = Purchase.new(:invoice => invoice)
		if Supplier.last.nil?
			redirect_to new_supplier_path, notice: 'Supplier Not Available. Please add a supplier.'
		else
			respond_to do |format|
				format.html # new.html.erb
				format.json { render json: @purchase }
			end
		end
  end

  def sales_return
		purchase = Purchase.where("receipt_type like ?", "RE%").last
		invoice = purchase ? purchase.invoice.next : "RE - 1"
    @purchase = Purchase.new(:invoice => invoice)
		if Supplier.last.nil?
			redirect_to new_supplier_path, notice: 'Supplier Not Available. Please add a supplier.'
		else
			respond_to do |format|
				format.html # new.html.erb
				format.json { render json: @purchase }
			end
		end
  end
  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)
    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render json: @purchase, status: :created, location: @purchase }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchases/1
  # PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update_attributes(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :no_content }
    end
  end

  def add_purchase_products
	@product = Product.find_by_code(params[:product_code])
	@cprice = params[:cprice] == '' ? @product.stock_products.last.cprice : params[:cprice]
	@price = params[:price] == '' ? @product.stock_products.last.price : params[:price]
	@invoice_qty = params[:bill_qty]
	@rec_qty = params[:rec_qty]
	@qty = params[:qty] == '' ? 1 : params[:qty]
	render :partial => 'purchase_product', :locals => {:purchase_product_object => PurchaseProduct.new(:product_id => @product.id, :cprice => @cprice, :price => @price, :invoice_qty => @invoice_qty, :received_qty => @rec_qty, :qty => @qty)}
  end
	
  def report
#	render :layout => 'report_layout'
  end

  def purchase_report_pdf
		pdf = PurchaseReportPdf.new(params[:from], params[:to])
		send_data pdf.render, filename: "report.pdf",
								type: "application/pdf",
								disposition: "inline"
  end
=begin	
  def purchase_report
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
    @purchases = Purchase.includes({purchase_products: :product}, :supplier).where(:purchase_date  => @from..@to)
		@total_purchase = 0
#	@purchases = @purchases.where(:supplier_id => params[:supplier]) if params[:supplier]
	  render :partial => 'purchase_report'
  end
=end
	
  def purchase_report
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
    @purchases = Purchase.includes({purchase_products: :product}, :supplier).where(:purchase_date  => @from..@to)
    @purchases = @purchases.where("invoice like ?", "#{params[:report_type][0..1]}%") unless params[:report_type] == "ALL"
		@total_purchase = 0
	  render :partial => 'purchase_report'
  end
	
  def payables
    @purchases = Purchase.where(:paid  => 0)
  end
	
  # PUT /purchases/1
  # PUT /purchases/1.json
  def pay_now
	@purchase.paid = 1
    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase Payment Made.' }
        format.json { head :no_content }
      else
        format.html { render action: "pay_now" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def supplier_report
  end
	
  def supplier_wise_report
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
		@supplier = Supplier.find(params[:supplier])
    @purchases = Purchase.where(:purchase_date  => @from..@to)
		@purchases = @purchases.where(:supplier_id => @supplier.id)
	  render :partial => 'supplier_wise_report'
  end
	
  def purchase_return
		@total_purchase = 0
		@purchase.purchase_products.each { |pp| @total_purchase += pp.qty * pp.cprice }

	end
	
	def last_od
		receipt_type = params[:id]
		purchase = Purchase.where("receipt_type like ?", "#{receipt_type}%").last
		@invoice = purchase ? purchase.invoice.next : "#{receipt_type[0..1]} - 1"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoice.to_json }
    end
	end
	
	def search
	end
	
	def search_result
		@purchase = Purchase.find_by_invoice(params[:term])
		unless @purchase.nil?
		@total_purchase = 0
		@purchase.purchase_products.each { |pp| @total_purchase += pp.qty * pp.cprice }		
			respond_to do |format|
        format.html { render action: "show",  :notice => "Sale fouund." }
				format.json { render json: @sale }
			end
		else
        render(action: "search", notice: 'Purchase could not be fouund.' )
		end
	end

  def purchase_register
    if (params[:from].present? && params[:to].present?)
			@from = Date.strptime(params[:from])
			@to = Date.strptime(params[:to])
			@purchases = Purchase.where(:purchase_date  => @from..@to)
			@purchases = @purchases.where(:receipt_type  => 'CBP') if params[:report_type] == 'CB'
			@purchases = @purchases.where(:receipt_type  => 'ODP') if params[:report_type] == 'OD'
			suppliers = @purchases.pluck(:supplier_id).uniq
			@suppliers = Supplier.includes(purchases: :purchase_products).find(suppliers)
			@purchase = Hash.new
			@total_purchase = 0
			
			for mydate in @from..@to
				purchases = @purchases.where(:purchase_date  => mydate)
				total_purchase = 0
				purchases.each do |purchase|
					pp = purchase.purchase_products.sum(:cprice)
					total_purchase += pp
				end
				@purchase[mydate] = total_purchase.round(2) unless total_purchase.zero?
				@total_purchase += total_purchase
			end
			
			respond_to do |format|
				if params[:report_type] == 'CB'
					format.html { render :partial => 'cb_purchase_register' }
					format.pdf do
						pdf = CbPurchaseRegisterPdf.new(@from, @to, @total_purchase, @purchase)
						send_data pdf.render, filename: "cb_purchase_register_for_#{@from}_#{@to}.pdf", type: "application/pdf", disposition: "inline"
					end
				elsif params[:report_type] == 'OD'
					format.html { render :partial => 'od_purchase_register' }
					format.pdf do
						pdf = OdPurchaseRegisterPdf.new(@from, @to, @total_purchase, @purchase)
						send_data pdf.render, filename: "od_purchase_register_for_#{@from}_#{@to}.pdf", type: "application/pdf", disposition: "inline"
					end
				elsif params[:report_type] == 'supplier wise'
					format.html { render :partial => 'supplier_wise_register' }
				else
					format.html { render :partial => 'purchase_register' }
	#				format.json { render json: @sales }
					format.pdf do
						pdf = PurchaseRegisterPdf.new(@from, @to, @total_purchase, @purchase)
						send_data pdf.render, filename: "purchase_register_for_#{@from}_#{@to}.pdf", type: "application/pdf", disposition: "inline"
					end
				end
			end			
		end
  end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:invoice, :receipt_type, :paid, :purchase_date, :supplier_id, :suppliers_invoice, :invoice_date, :amount, :transport, :lr_no, :discount, :freight, :dc, :vat, :cst, :duty, :edu_cess, :surcharge, :round_off, :debit_note, :purchase_products_attributes => [:id, :price, :cprice, :product_id, :purchase_id, :qty, :invoice_qty, :received_qty], new_purchase_product_attributes:[:id, :price, :cprice, :product_id, :purchase_id, :qty, :invoice_qty, :received_qty])
    end
end
