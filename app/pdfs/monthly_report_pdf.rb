class MonthlyReportPdf < Prawn::Document
	def initialize(from, to)
		super(options = {:margin => [10, 10, 0, 10]})
		font "Times-Roman"
		font_size 10
		@grand_open = 0
		@grand_arrival = 0
		@grand_issue = 0
		@grand_close = 0
		
		
	    product_ids = PurchaseProduct.uniq.pluck(:product_id)
		@products = Product.find(product_ids)
	  
		@from = Date.strptime(from)
	    @to = Date.strptime(to)
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
		x = line_item_rows
		table line_item_rows do
		  row(0).font_style = :bold
		  self.row_colors = ["DDDDDD", "FFFFFF"]
		  self.header = true
		end
	end
	
	def line_item_rows
		@items =Array.new
		@items.push ["Product", "unit", "Qty", "Cost Price", "Amount", "Sales Price", "Amount", "Profit"]
		profit = 0.0
		gross_profit = 0.0
			
		@products.each.map do |product|

			tot_sales = product.sale_on_date_range(@from, @to)
			profit = tot_sales["price"].to_f - tot_sales["cprice"].to_f
			gross_profit += profit
			
		  @items.push [product.name, product.unit, tot_sales["qty"], tot_sales["cprice"].to_f / tot_sales["qty"].to_i, tot_sales["cprice"],  tot_sales["price"].to_f / tot_sales["qty"].to_i,  tot_sales["price"], profit]
		end
		@items.push ["", "", "", "","", "", "Total", gross_profit ]
		@items
	end
	
end
