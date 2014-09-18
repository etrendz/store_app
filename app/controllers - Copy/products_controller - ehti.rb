class ProductsController < ApplicationController
  before_filter :set_product, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  before_filter :authorize, except: [:home, :index, :products_name, :ecount, :product_code, :show, :barby_barcode_generate, :generate_barcode]
  # GET /products
  # GET /products.json
	
	def home
	end
	
  def index
    @products = Product.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
			format.csv { render text: @products.to_csv }
    end
  end

  def products_name
		@products = Product.where("name like ?", "%#{params[:term]}%")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end
 
  def product_show
    @product = Product.find_by_name(params[:name])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end
 
  def import
	Product.import(params[:file])
	redirect_to root_url, notice: "Items imported."
  end
  
  # GET /products/1
  # GET /products/1.json
  def show
		@purchases = Hash.new
		@transactions = Array.new
		@sss =""
 #   @product = Product.find(params[:id])
    @product = Product.includes({purchase_products: :purchase}, {sale_products: :sale}, {sale_returns: :sale}, :stock_products).find(params[:id])
		
		@product.purchase_products.each do |pp|
			@transactions.push({:date => pp.purchase.purchase_date, :qty => pp.qty, :cprice => pp.cprice, :type => 'Purchase' })
		end
		
		@product.sale_returns.each do |sr|
			@transactions.push({:date => sr.created_at.to_date, :qty => sr.qty, :price => sr.price, :type => 'Return' })
		end
		
		@product.sale_products.each do |sp|
			@transactions.push({:date => sp.sale.sale_date, :qty => sp.qty, :price => sp.price, :type => 'Sale' })
		end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
	code = Product.last ? Product.last.code.next : '000001'
    @product = Product.new(:code => code)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update_attributes(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
	
  def select_month_range
  end

  def monthly_report_pdf
		pdf = MonthlyReportPdf.new(params[:from], params[:to])
		send_data pdf.render, filename: "report.pdf",
								type: "application/pdf",
								disposition: "inline"
  end
	
  def monthly_range_report
	  product_ids = PurchaseProduct.uniq.pluck(:product_id)
		@products = Product.find(product_ids)
	  
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
	  render :partial => 'monthly_range_report'
  end
	
  def ecount
    @product = Product.find_by_name(params[:item])
	 render json: @product 
  end
  
  def backup
		config   = Rails.configuration.database_configuration
		database = config[Rails.env]["database"]
		username = config[Rails.env]["username"]
		password = config[Rails.env]["password"]
    result = system "mysqldump --opt --user=#{username} --password=#{password} #{database} > dbs/store_#{Time.now.strftime('%Y%m%d%H%M%S')}.sql"
		if result
			redirect_to '/', notice: 'Product was successfully Backedup.'
		else
			redirect_to '/', notice: 'Unable to Backup '
		end
		
	 		
  end

  def restore
	path = Rails.root.join('dbs')
	redirect_to '/', notice: 'Product was successfully Backedup.'
	 		
  end

  def barcode
	
  end
	
  def calender
		@day_sales = []
		
		j=Date.today.day - 1
		for i in 1..Date.today.day do
				@day_sales[i] = 0
			# calculating the daily sales
				day_sale = Sale.where(:sale_date => (Date.today - j.days))
		#		p day_sale.id
				day_sale.each do |s|
			
				total_sales = s.sale_products.sum(:price)
				discount = (total_sales * (s.discount).to_i / 100)
				vat = (total_sales - discount) * (s.vat).to_i / 100
		
	#			@day_sales += s.sale_products.map(&:price).sum
				@day_sales[i] += (total_sales - discount + vat)
				j -= 1
			end
		end
  end
  
  # GET /products/1
  # GET /products/1.json
  def product_code
    @product = Product.find_by_code(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end
  

  def barby_barcode
  names = Array.new
 # qty = params[:bcode_qty].to_i
  @products = Array.new
  text = params[:bcode]
  84.times do |i|
	names.push params[("bcode"+(i+1).to_s).to_sym] 
#	p ("bcode"+i.to_s).to_sym
  end
	  Prawn::Labels.types = {
	  "Agipa119461" => {
		"top_margin"    => 59,
		"bottom_margin" => 49,
		"left_margin"   => 22,
		"right_margin"  => 15,
		"columns"       => 4,
		"rows"          => 21,
		"column_gutter" => 20,
		"row_gutter"    => 7
	}}
  labels = Prawn::Labels.render(names, :type => "Agipa119461") do |pdf, name|
		product = Product.find_by_code(name)
        barcode = Barby::Code39.new name
		if product
			barcode.annotate_pdf(pdf, {:y => 10, :height => 18, :xdim => 1.15, :ydim => 0.65})
		else
			pdf.text ' '
		end
			pdf.text product.name, :align => :left, :valign => :bottom, :size => 6 if product
			pdf.text "Rs."+product.stock_products.last.price.to_s+"  .", :align =>  :right, :valign => :bottom, :size => 6 if product && product.stock_products.last
			pdf.text name, :align => :center, :valign => :bottom, :size => 6
#	pdf.text name
  end

  send_data labels, filename: "names.pdf", type: "application/pdf", disposition: "inline"

  end


  def barby_barcode_generate
  names = Array.new
	@products = Product.all
	(params[:start_from].to_i - 1).times do
		names.push " "
	end
		@products.each do |product|
			if params["barcode_check_#{product.id}".to_sym] == "on"
				qty = (params["barcode_qty_#{product.id}".to_sym]).to_i
				qty.times do 
					names.push product.code
				end
			end
		end
	Prawn::Labels.types = {
	  "Agipa119461" => {
		"top_margin"    => 59,
		"bottom_margin" => 49,
		"left_margin"   => 22,
		"right_margin"  => 15,
		"columns"       => 4,
		"rows"          => 21,
		"column_gutter" => 20,
		"row_gutter"    => 7
	}}
  labels = Prawn::Labels.render(names, :type => "Agipa119461") do |pdf, name|
	  product = Product.find_by_code(name)
		barcode = Barby::Code39.new name
		if product
			barcode.annotate_pdf(pdf, {:y => 10, :height => 18, :xdim => 1.15, :ydim => 0.65})
		else
			pdf.text ' '
		end							
		pdf.text product.name, :align => :left, :valign => :bottom, :size => 6 if product
		pdf.text "Rs."+product.stock_products.last.price.to_s+"  .", :align =>  :right, :valign => :bottom, :size => 6 if product && product.stock_products.last
		pdf.text name, :align => :center, :valign => :bottom, :size => 6
	
	end

  send_data labels, filename: "names.pdf", type: "application/pdf", disposition: "inline"

  end
	
  def barby_barcode_single
	  names = Array.new
	  qty = params[:bcode_qty].to_i
	  @product = Product.find_by_code(params[:bcode])
	  text = params[:bcode]
	  qty.times do 
	  names.push text
	  end
	  Prawn::Labels.types = {
	  "Agipa119461" => {
		"top_margin"    => 59,
		"bottom_margin" => 49,
		"left_margin"   => 22,
		"right_margin"  => 15,
		"columns"       => 4,
		"rows"          => 21,
		"column_gutter" => 20,
		"row_gutter"    => 7
	}}
	  labels = Prawn::Labels.render(names, :type => "Agipa119461") do |pdf, name|
			barcode = Barby::Code39.new name
			barcode.annotate_pdf(pdf, {:y => 10, :height => 18, :xdim => 1.15, :ydim => 0.65})
			pdf.text @product.name, :align => :left, :valign => :bottom, :size => 6 if @product
			pdf.text "Rs."+@product.stock_products.last.price.to_s+"  .", :align =>  :right, :valign => :bottom, :size => 6 if @product && @product.stock_products.last
			pdf.text name, :align => :center, :valign => :bottom, :size => 6
	#	pdf.text name
	  end
	  send_data labels, filename: "names.pdf", type: "application/pdf", disposition: "inline"
  end
  
  def search_products
		@products = Product.where("name like ?", "%#{params[:term]}%")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products.limit(5).map(&:name) }
    end
  end
	
	def stock_report
		@opening_stock = Hash.new
		@purchase_stock = Hash.new
		@sale_stock = Hash.new
		@sale_return_stock = Hash.new
		
		@total_stock_price = 0
		@products = Product.includes({purchase_products: :purchase}, {sale_products: :sale})
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
		
		@products.each do |product|
				@opening_stock[product.id] = product.opening(@from)
				@purchase_stock[product.id] = product.purchase_on_date_range(@from, @to)
				@sale_stock[product.id] = product.sale_on_date_range(@from, @to)
				@sale_return_stock[product.id] = product.sale_return_on_date_range(@from, @to)
		end
	  render :partial => 'stock_report'
	end
	
	
	def stock_report_pdf
		@opening_stock = Hash.new
		@purchase_stock = Hash.new
		@sale_stock = Hash.new
		@sale_return_stock = Hash.new
		
		@total_stock_price = 0
		@products = Product.includes({purchase_products: :purchase}, {sale_products: :sale})
		@from = Date.strptime(params[:from])
	  @to = Date.strptime(params[:to])
		
		@products.each do |product|
				@opening_stock[product.id] = product.opening(@from)
				@purchase_stock[product.id] = product.purchase_on_date_range(@from, @to)
				@sale_stock[product.id] = product.sale_on_date_range(@from, @to)
				@sale_return_stock[product.id] = product.sale_return_on_date_range(@from, @to)
		end
		pdf = StockReportPdf.new(@from, @to, @opening_stock, @purchase_stock, @sale_stock, @sale_return_stock, @products)
		send_data pdf.render, filename: "report.pdf",
								type: "application/pdf",
								disposition: "inline"
	end
	
  def search
		@purchases = Hash.new
		@transactions = Array.new
		@sss =""
		@product = Product.find_by_code(params[:term])
		@product.purchase_products.each do |pp|
			@transactions.push({:date => pp.purchase.purchase_date, :qty => pp.qty, :cprice => pp.cprice, :type => 'Purchase' })
		end
		
		@product.sale_returns.each do |sr|
			@transactions.push({:date => sr.created_at.to_date, :qty => sr.qty, :price => sr.price, :type => 'Return' })
		end
		
		@product.sale_products.each do |sp|
			@transactions.push({:date => sp.sale.sale_date, :qty => sp.qty, :price => sp.price, :type => 'Sale' })
		end
		render 'show'
  end
	
	def graph
		@low_stock = 0
		@total_products = Product.count
		@products = []
		@sale_with_date = Hash.new(0)
		@profit_with_date = Hash.new(0)
		@sale_with_date1 = Hash.new
		@sale_cat_with_date = Hash.new(0)
		@day_sales = 0
		@week_sales = 0
		@month_sales = 0
		@price = Array.new
		
		@color = {1 => '#68BC31', 2 => '#2091CF', 3 => '#AF4E96', 4 => '#DA5430', 5 => '#FEE074', 6 => '#68B074', 7 => '#E9668B', 8 => '#B86C31', 9 => '#33368B', 10 => '#777C31', 11 => '#AAAC31', 12 => '#3E91CF', 13 => '#244E96', 14 => '#D15430', 15 => '#4EE074', 16 => '#B85074', 17 => '#E15A8B', 18 => '#B47231', 19 => '#33368B', 20 => '#777C31', 21 => '#AAAC31', 22 => '#3E91CF', 23 => '#244E96', 24 => '#D15430', 25 => '#4EE074', 26 => '#B85074', 27 => '#E15A8B', 28 => '#B47231', 29 => '#33368B', 30 => '#777C31', 31 => '#AAAC31', 32 => '#3E91CF', 33 => '#244E96', 34 => '#D15430', 35 => '#4EE074', 36 => '#B85074', 37 => '#E15A8B', 38 => '#B47231' }
		
		Product.all.each 	do |product|
			if product.stock_products.length < 10
					@low_stock += 1
					@products.push product
			end
		end
		@this_month_sales = Sale.where(:sale_date => [(Date.today - 1.month)..Date.today])

		month_sales = Sale.includes(sale_products: :product).where(:sale_date => [(Date.today - 1.month)..Date.today])
		week_sales = month_sales.where(:sale_date => [(Date.today - 1.week)..Date.today])
		
		
		
		# calculating the monthly sales
		month_sales.each do |s|
			total_sales = s.sale_products.sum(:price)
			discount = (total_sales * (s.discount).to_i / 100)
			vat = (total_sales - discount) * (s.vat).to_i / 100
			@month_sales += (total_sales - discount + vat)
		end
							
			week_sales.each do |sale|
			
			profit = 0
				total_sales = sale.sale_products.sum(:price)
				total_cost = sale.sale_products.sum(:cprice)
				discount = (total_sales * (sale.discount).to_i / 100)
				vat = (total_sales - discount) * (sale.vat).to_i / 100
		
				net_sales = (total_sales - discount + vat)
				@sale_with_date[sale.sale_date] += net_sales
				profit = (total_sales - discount + vat - total_cost)
				@profit_with_date[sale.sale_date] += profit
				
			@week_sales += (total_sales - discount + vat)
	#			sale.sale_products.each do |sp|
		#			@sale_cat_with_date[sp.product.category.id] += net_sales
			end
			
			
			
			
		@categories = Category.includes({products: :sale_products})
		@eprice = Hash.new(0)
		
		@g_total = 0 
			@categories.each { |category| 
			  @price[category.id] = 0
			  category.products.each { |product| 
					product.sale_products.each { |sp|
						if @this_month_sales.include?sp.sale 
							@price[category.id] = @price[category.id] + ( sp.price - (sp.price * sp.sale.discount / 100))
						end
					}
			  }
			  @g_total += @price[category.id]
			}
	
	end
	
	def dead_stock
		@dead_stocks = StockProduct.where('created_at < ?', (Date.today -1.day)).uniq.pluck(:product_id, :created_at)
		
	#	@dead_products = Product.find(dead_stocks)
	end
	
	def my_report_csv
		from = Date.strptime(params[:from])
		to = Date.strptime(params[:to])
		@data = stock_report_csv(from, to)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data}
			format.csv { render text: @data }
    end
  end
	
	def generate_barcode
		@products = Product.where('qty > 0').paginate(:page => params[:page], :per_page => 15)
	end
	
	def generate_barcode_from_purchase
		@purchase = Purchase.find(params[:id])
		products = @purchase.purchase_products.pluck(:product_id)
		@products = Product.find(products)
#		render 'generate_barcode'
	end
	
  # Fetches the new product obj for modal in purchase page
  def new_product
	code = Product.last ? Product.last.code.next : '000001'
    @product = Product.new(:code => code)

    respond_to do |format|
      format.html { render partial: 'new_product' }
      format.json { render json: @product }
    end
  end

  private
	
	def stock_report_csv(from, to)
		opening_stock = Hash.new
		purchase_stock = Hash.new
		sale_stock = Hash.new
			
		total_opening_price = 0
		total_purchase_price = 0
		total_sale_price = 0
		total_closing_value = 0 
		
		products = Product.includes({purchase_products: :purchase}, {sale_products: :sale})
		
		heading = ["S.No", "Product", "Opening Stock", "Opening Value", "Purchase Stock", "Purchase Value", "Sales Stock", "Sales Value", "Closing Stock", "Closing Value"]
		i = 1
		CSV.generate do |csv|
			csv << heading
			products.each do |product|
				opening_stock[product.id] = product.opening(from)
				purchase_stock[product.id] = product.purchase_on_date_range(from, to)
				sale_stock[product.id] = product.sale_on_date_range(from, to)
			  total_opening_price += opening_stock[product.id]["price"] 
			  total_purchase_price += purchase_stock[product.id]["price"] 
			  total_sale_price += sale_stock[product.id]["price"] 
			  closing_stock = opening_stock[product.id]["qty"] + purchase_stock[product.id]["qty"] - sale_stock[product.id]["qty"] 
			  closing_value = opening_stock[product.id]["price"] + purchase_stock[product.id]["price"] - sale_stock[product.id]["cprice"] 
				total_closing_value += closing_value
				
				csv << [i, product.name, opening_stock[product.id]['qty'], opening_stock[product.id]['price'], purchase_stock[product.id]['qty'], purchase_stock[product.id]['price'], sale_stock[product.id]['qty'], sale_stock[product.id]['price'], closing_stock, closing_value]
		end
		end
	end
		
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:category_id, :name, :size, :cprice, :price, :description, :qty, :unit, :code, :_delete, :sold_products_attributes)
    end
end
