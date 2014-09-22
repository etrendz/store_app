class OdPurchaseRegisterPdf < Prawn::Document
	def initialize(from, to, total_purchase, od_purchase)
		super()
		font "Times-Roman"
		@items =Array.new
		
		@from = from
		@to = to
		@total_purchase = total_purchase
		@od_purchase = od_purchase
		
			
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
		move_down(20)
		text "OD Purchase Report: #{@from.strftime('%d %b')} - #{@to.strftime('%d %b, %Y')}", :size => 18
		move_down(12)
		line_items
		move_down(20)
		
	end
	
	def draw_a_line
		stroke do
		  stroke_color '990000'
		  dash(5, space: 0, phase: 0)
		  line_width 2
		  stroke_horizontal_rule
		end
	end
	
	def line_items
		icount = 0
		table line_item_rows,:position => :center, :header => true, :cell_style => {:border_widths => [0, 1, 1, 1],:border_color => "d6e9c6", :size =>12} do
		  icount += 1
		  row(0).font_style = :bold
		  row(0).text_color = "000000"
		  row(0).background_color = "cff0d6"
		  column(0).width = 150
		  column(1).width = 150
		  column(2).width = 150
		  column(column_length - 1).align =  :right
		  row(row_length - 1).background_color = "dff0d8"
		  row(0).align = :center
		end
		
	end
	
	def line_item_rows
		@items.push ["Date","Day", "CB Value"]
		@od_purchase.each.map do |k,v|
			@items.push [k.strftime('%d-%m-%Y'), k.strftime("%A"),  sprintf('%.2f', v)]
		end
		@items.push ["Total", "", sprintf('%.2f', @total_purchase)]

		@items
	end
	
end
