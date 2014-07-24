class PurchasePdf < Prawn::Document
	def initialize(purchase, total_purchase)
		super()
		font "Times-Roman"
		@items =Array.new
		@total_purchase = total_purchase
		@purchase = purchase
		move_down(10)
		text "Purchase Details", :size => 16
		move_down(10)
		line_items
	end
	
	
	def line_items
		icount = 0
		table line_item_rows, :header => true, :cell_style => {:border_widths => [0, 0, 1, 0],:border_color => "d6e9c6", :size =>12} {
		  icount += 1
		  row(0).font_style = :bold
		  row(0).text_color = "468847"
		  row(0).background_color = "cff0d6"
		  row(1).background_color = "dff0d8"
		#  self.row_colors = ["DDDDDD", "FFFFFF"]
		  column(0).width = 50
		  column(1).width = 100
		  column(4).width = 100
		 row(row_length - 1).background_color = "dff0d8"
		}
	end
	
	def line_item_rows
		@items.push ["Date", "Supplier", "Invoice", "Paid","Product", "Qty", "Unit", "Price", "Full Price"]
		@items.push [@purchase.purchase_date.strftime('%d %b'), (@purchase.supplier.name if @purchase.supplier), @purchase.invoice, @purchase.paid ? "Yes" : "No", "", "", "", "", ""]
		@purchase.purchase_products.each.map do |item| 
			@items.push ["", "", "", "", item.product.name, item.product.unit, item.qty, item.cprice, item.cprice * item.qty]
		end
		@items.push ["Total", "", "",  "", "", "", "", "", (@total_purchase)]

		@items
	end
	
end
