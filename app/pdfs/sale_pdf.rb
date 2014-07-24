class Integer
	Ones = %w[ Zero One Two Three Four Five Six Seven Eight Nine ]
	Teen = %w[ Ten Eleven Twelve Thirteen Fourteen Fifteen
	sixteen Seventeen Eighteen Nineteen ]
	Tens = %w[ Zero Ten Twenty Thirty Forty Fifty
	Sixty Seventy Eighty Ninety ]
	Mega = %w[ none Thousand Million Billion ]

	def to_english
		places = to_s.split(//).collect {|s| s.to_i}.reverse
		name = []
		((places.length + 2) / 3).times do |p|
			strings = Integer.trio(places[p * 3, 3])
			name.push(Mega[p]) if strings.length > 0 and p > 0
			name += strings
		end
		name.push(Ones[0]) unless name.length > 0
		name.reverse.join(" ")
	end
	private
	def Integer.trio(places)
		strings = []
		if places[1] == 1
			strings.push(Teen[places[0]])
		elsif places[1] and places[1] > 0
			strings.push(places[0] == 0 ? Tens[places[1]] : "#{Tens[places[1]]}-#{Ones[places[0]]}")
		elsif places[0] > 0
			strings.push(Ones[places[0]])
		end
		if places[2] and places[2] > 0
			strings.push("Hundred", Ones[places[2]])
		end
		strings
	end
end

class SalePdf < Prawn::Document
	def initialize(sale, total_sales)
		super()
		font "Times-Roman"
		@items =Array.new
		@sale = sale
		@total_sales = total_sales
		@discount = (@total_sales * (@sale.discount).to_i / 100)
		@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
		
		text "TIN : 33264263729", :size => 10, :align => :left
		text "Mobile No : 9655583812", :size => 10, :align => :left
		text "Phone : 04174 244466", :size => 10, :align => :left		
move_down(10)
		text "JAWHAR PLAZA", :size => 28, :align => :center
#		move_up(28)
#		text "Invoice", :size => 22, :align => :right
		text "# 194/43 Nethaji Road, Ambur - 635802. Vellore District.", :size => 12, :align => :center
#		text "Triplicane, Chennai - 03.", :size => 10, :align => :left
		move_down(10)
		draw_a_line()
		move_down(10)
		text "INVOICE: ##{@sale.id}", :size => 10, :align => :right
		move_down(5)
		text "DATE: #{@sale.sale_date.strftime('%d-%m-%Y')}", :size => 8, :align => :right
		move_down(5)
		text "ORDER NO: #{@sale.customer.id if @sale.customer}", :size => 10, :align => :right
	#	move_down(10)
	#	draw_a_line()
		move_up(38)
		add_from
		move_down(20)
		line_items
		move_down(20)
		
		bounding_box [bounds.left, bounds.bottom + 125], :width => bounds.width do
			font "Helvetica"
		text "For JAWHAR PLAZA", :size => 14, :align => :right
			move_down(70)
#		text "Thank you for your business", :size => 12, :align => :center
#			move_down(10)
			stroke_horizontal_rule
			move_down(10)
			text "Goods are dispatched at the purchaser's risk.", :size => 10
			move_down(5)
			text "For all disputes, the legal jurisdiction is Ambur only ", :size => 10
		end
	end
	
	def add_from
		text "Bill to : ", :size => 14, :align => :left
		move_down(5)
		text "#{@sale.customer.name if @sale.customer}", :size => 14, :align => :left
		text "# #{@sale.customer.mobile if @sale.customer}", :size => 14, :align => :left
		text "Address : #{@sale.customer.address if @sale.customer}", :size => 14, :align => :left
		text "Tin :  #{@sale.customer.tin if @sale.customer}", :size => 14, :align => :left
		
		move_down(5)
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
		#  row(1).background_color = "dff0d8"
		#  self.row_colors = ["DDDDDD", "FFFFFF"]
		  column(1).width = 300
		  column(column_length - 1).align =  :right
		 row(row_length - 5).column(1).align = :right
		 row(row_length - 4).column(1).align = :right
		 row(row_length - 3).column(1).align = :right
		 row(row_length - 2).column(1).align = :right
		 row(row_length - 1).background_color = "dff0d8"
		end
		move_down(40)
		text "RUPEES IN WORDS : "
		move_down(20)
		text (@total_sales - @discount + @vat).to_i.to_english
	end
	
	def line_item_rows
		i = 1
		@items.push ["S.No","Product", "Qty", "Price", "Full Price"]
		#@items.push [@sale.sale_date.strftime('%d %b'), (@sale.customer.name if @sale.customer), @sale.paid ? "Yes" : "No", "", "", "", ""]
		@sale.sale_products.each.map do |item| 
			@items.push ["#{i}.", item.product.name,  item.qty, item.price / item.qty  , item.price]
			i += 1
		end
		@items.push ["", "Total", "", "", (@total_sales.round(2))]
		@items.push ["", "Discount", "", "", (@sale.discount).to_f.round(2)]
		@items.push ["", "Total", "", "", (@total_sales - @discount).round(2)]
		@items.push ["", "VAT #{(@sale.vat)}%", "", "", @vat.round(2)]
		@items.push ["Total", "", "", "", (@total_sales - @discount + @vat).round(2)]

		@items
	end
	
end
