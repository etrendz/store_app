class PurchasePdf < Prawn::Document
	def initialize(purchase)
		super(options = {:page_size   => [720, 432], :margin => [0, 0, 0, 0]})
		font "Times-Roman"
		default_leading 0
		@purchase = purchase
		move_down(206)
		received_from
		move_up(16)
		mrr
		move_down(10)
		supplier
		move_down(10)
		purchase_number
		line_items
	end
	
	def purchase_number
#		text "#{@purchase.invoice}			#{@purchase.purchase_date}			#{@purchase.invoice}			#{@purchase.purchase_date}", :size =>10
		draw_text "#{@purchase.invoice}", :size =>10, :at => [5, 261]
		draw_text "#{@purchase.purchase_date.strftime('%d-%b-%y')}", :size =>10, :at => [75, 261]
		draw_text "#{@purchase.invoice}", :size =>10, :at => [175, 261]
		draw_text "#{@purchase.purchase_date.strftime('%d-%b-%y')}", :size =>10, :at => [245, 261]
	end
	def supplier
		draw_text "#{@purchase.supplier.name}", :size =>10, :at => [47, 298]
	#	text "#{@purchase.supplier.name}", :size =>10, :leading => 0
	end
	def received_from
		draw_text "#{@purchase.supplier.name}", :size =>10, :at => [47, 325]
	#	text "#{@purchase.received_from}", :size =>10, :leading => 0
	end
	def mrr
		draw_text "UC-#{@purchase.id}", :size =>13, :font_weight => :bold, :at => [415, 320]
		draw_text "#{@purchase.created_at.to_date.strftime('%d-%b-%y')}", :size =>10, :font_weight => :bold, :at => [500, 325]
#		text "UC-#{@purchase.id}", align: :right, :leading => 0
	end
	def line_items
		table line_item_rows, :cell_style => {:border_widths => [0, 0, 0, 0], :size =>10, :padding => [0,10, 0, 0]} do
		#  row(0).font_style = :bold
		  #self.row_colors = ["DDDDDD", "FFFFFF"]
#		  self.header = true
		  column(0).width = 210
		  column(1).width = 70
		  column(2).width = 70
		  column(3).width = 50
		  column(4).width = 70
		  column(0..4).height = 13
		end
	end
	
	def line_item_rows
		#[["product", "Qty", "unit Price", "Full Price"]] + 
		@purchase.purchase_products.each.map do |item|
			[item.product.name, item.product.unit, item.qty, item.qty, item.purchase.purchase_date.strftime('%d-%b-%y')]
		end
	end
	
	
end
