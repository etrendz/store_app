class SalesRegisterPdf < Prawn::Document
	def initialize(from, to, total_sale, total_cb_sale, total_cd_sale, cb_sale, cd_sale)
		super()
		font "Times-Roman"
		@items =Array.new
		
		@from = from
		@to = to
		@total_sale = total_sale
		@total_cb_sale = total_cb_sale
		@total_cd_sale = total_cd_sale
		@cb_sale = cb_sale
		@cd_sale = cd_sale
		
			
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
		text "Sales Register: #{@from.strftime('%d %b')} - #{@to.strftime('%d %b, %Y')}", :size => 18
		move_down(25)
#		text "DATE: #{@sale.sale_date.strftime('%d-%m-%Y')}", :size => 8, :align => :right
		move_down(5)
#		text "ORDER NO: #{@sale.customer.id if @sale.customer}", :size => 10, :align => :right
	#	move_down(10)
	#	draw_a_line()
		move_up(38)
		move_down(20)
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
		  column(0).width = 90
		  column(1).width = 90
		  column(2).width = 90
		  column(3).width = 90
		  column(4).width = 90
		  column(5).width = 90
		  column(column_length - 1).align =  :right
		  column(column_length - 2).align =  :right
		  column(column_length - 3).align =  :right
		  column(column_length - 4).align =  :left
		  row(row_length - 1).background_color = "dff0d8"
		  row(0).align = :center
		end
		
	end
	
	def line_item_rows
		@items.push ["Date","Day", "CB Value", "CD Value", "Total"]
		@total_sale.each.map do |k,v|
			@items.push [k.strftime('%d-%m-%Y'), k.strftime("%A"),  sprintf('%.2f', @cb_sale[k]), sprintf('%.2f', @cd_sale[k]), sprintf('%.2f', v) ]
		end
		@items.push ["Total", "", sprintf('%.2f', @total_cb_sale), sprintf('%.2f', @total_cd_sale), sprintf('%.2f', (@total_cb_sale + @total_cd_sale))]

		@items
	end
	
end
