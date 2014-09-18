class StockReportPdf < Prawn::Document
	def initialize(from, to, opening_stock, purchase_stock, sale_stock, sale_return_stock, products)
		super(options = {:margin => [10, 10, 0, 10],  :page_layout => :portrait})
		font "Times-Roman"
		font_size 10
		@grand_open = 0
		@grand_arrival = 0
		@grand_issue = 0
		@grand_close = 0
		@total_closing_value = 0 
		@total_opening_price = 0
		@total_purchase_price = 0
		@total_sale_price = 0
		@total_sale_return_price = 0
		@opening_stock = opening_stock
		@purchase_stock = purchase_stock
		@sale_stock = sale_stock
		@sale_return_stock = sale_return_stock
		
	    product_ids = PurchaseProduct.uniq.pluck(:product_id)
		@products = Product.find(product_ids)
	  
		@from = from
	    @to = to
			
			
			
			
			
		text "TIN : 33414621625", :size => 10, :align => :left
		text "CST : 368379", :size => 10, :align => :left
		text "Phone : 04179 222896", :size => 10, :align => :left		
move_down(10)
		text "MENS FASHION", :size => 28, :align => :center
#		move_up(28)
#		text "Invoice", :size => 22, :align => :right
		text "# 59/1, Vaniyambadi Road, Tirupattur - 635 601.", :size => 12, :align => :center
#		text "Triplicane, Chennai - 03.", :size => 10, :align => :left
		move_down(10)
		draw_a_line()
		move_down(10)
		
		issue_number
		line_items
	end
	
	def issue_number
		text "Stock Report", size: 26, style: :bold
		move_down 20
		text "From: #{@from.strftime('%d-%b-%y')}  To: #{@to.strftime('%d-%b-%y')}", size: 16
	end
	def line_items
		move_down 20
		table line_item_rows,:position => :center, :header => true, :cell_style => {:border_widths => [0, 1, 0, 1],:border_color => "d6e9c6", :size =>12} do
		  row(0).font_style = :bold
	#	  self.row_colors = ["DDDDDD", "FFFFFF"]
		  row(0).background_color = "cff0d6"
		  row(1).background_color = "cff0d6"
		  column(1).width = 180
	#	  self.header = true
		 row(row_length - 1).background_color = "dff0d8"
		 row(row_length - 1).font_style = :bold
		end
	end
	
	def draw_a_line
		stroke do
		  stroke_color '990000'
		  dash(5, space: 0, phase: 0)
		  line_width 2
		  stroke_horizontal_rule
		end
	end
	
	def line_item_rows
		@items =Array.new
		@items.push ["S.No", "Product", {:content => "Opening", :colspan=> 2}, {:content => "Purchase", :colspan=> 2}, {:content => "Sales", :colspan=> 2}, {:content => "Return", :colspan=> 2}, {:content => "Closing", :colspan=> 2}]
		@items.push ["", "", "Qty", "Value", "Qty", "Price", "Qty", "Price", "Qty", "Price", "Stock", "Value"]
		profit = 0.0
		gross_profit = 0.0
		i = 1
		@products.each.map do |product|
		
			tot_sales = product.sale_on_date_range(@from, @to)
			profit = tot_sales["price"].to_f - tot_sales["cprice"].to_f
			gross_profit += profit
			
			@total_opening_price += @opening_stock[product.id]["price"]
			@total_purchase_price += @purchase_stock[product.id]["price"] 
			@total_sale_price += @sale_stock[product.id]["price"] 
			@total_sale_return_price += @sale_return_stock[product.id]["price"] 
			closing_stock = @opening_stock[product.id]["qty"] + @purchase_stock[product.id]["qty"] - @sale_stock[product.id]["qty"] 
			
			closing_value = @opening_stock[product.id]["price"] + @purchase_stock[product.id]["price"] - @sale_stock[product.id]["cprice"] 
			@total_closing_value += closing_value 
			
		  @items.push [i, product.name, @opening_stock[product.id]['qty'], @opening_stock[product.id]['price'], @purchase_stock[product.id]['qty'], @purchase_stock[product.id]["price"].round(2), @sale_stock[product.id]['qty'], @sale_stock[product.id]["price"].round(2), @sale_return_stock[product.id]['qty'], @sale_return_stock[product.id]["price"].round(2), closing_stock,  closing_value]
			i += 1
		end
		@items.push ["", "Total", "", @total_opening_price.round(2), "", @total_purchase_price, "", @total_sale_price, "", @total_sale_return_price , "", @total_closing_value.round(2) ]
		@items
	end
	
end
