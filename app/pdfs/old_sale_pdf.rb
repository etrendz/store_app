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
	def initialize(sale, total_sales, total_returns)
		super(options = {:margin => [4, 4, 0, 12], :page_size => [290, 1000], :print_scaling => :none})
		font "Times-Roman"
		@items =Array.new
		@sale = sale
		@total_sales = total_sales
		@total_returns = total_returns
		@discount = (@total_sales * (@sale.discount).to_i / 100)
		@vat = (@total_sales - @discount) * (@sale.vat).to_i / 100
			
move_down(10)
		text "TIN : 33414621625", :size => 9, :align => :left
		text "CST : 368379 / Dt: 18.08.1999", :size => 9, :align => :left
		move_up(12)
		text "Phone : 04179 222896", :size => 9, :align => :right
		move_down(5)
		
		font_families.update("Arial" => {
    :normal => "#{Rails.root}/app/assets/fonts/asia.ttf",
    :italic => "#{Rails.root}/app/assets/fonts/ariali.ttf",
    :bold => "#{Rails.root}/app/assets/fonts/arialbd.ttf",
    :bold_italic => "#{Rails.root}/app/assets/fonts/arialbi.ttf"
  })

  font "Arial"
  text "MEN'S FASHION", :size => 30, :align => :center
  font("Helvetica")
		
		text "# 59/1, Vaniyambadi Road,", :size => 10, :align => :center
		text "Tirupattur - 635 601.", :size => 10, :align => :center
		move_down(5)
		text "<u>CASH BILL""</u>",  :align => :center, :inline_format => true
		# draw_a_line()
		move_down(10)
		text "Bill No: #{@sale.invoice}", :size => 12, :align => :left
		move_up(20)
		text "DATE : #{@sale.sale_date.strftime('%d-%m-%y')}", :size => 10, :align => :right
		move_down(3)
		text "TIME: #{@sale.created_at.strftime('%I:%M %p')}", :size => 10, :align => :right
		move_down(25)
		move_up(38)
		move_down(20)
		line_items
		move_down(10)
		stroke_horizontal_rule
			move_down(10)
			text "Goods ones sold can not be Taken back or Exchange", :size => 10, :align => :center
			move_down(3)
			text "All Credit & Debit Cards Accepted, (No Service Charge).", :size => 10, :align => :center
			move_down(3)
			text "***THANK YOU VISIT AGAIN***MENS FASHION TPT", :size => 10, :align => :center
			move_down(5)
			draw_a_line()
	end
	
	def draw_a_line
		stroke do
		  stroke_color '000000'
		  dash(5, space: 0, phase: 0)
		  line_width 1
		  stroke_horizontal_rule
		end
	end
	
	def line_items
		table line_item_rows,:position => :center, :header => true,  :cell_style => {:border_widths => [0, 0, 0, 0], :padding => [2, 3, 2, 5], :style => :bold, :size =>10} do
		  row(0).font_style = :bold
		  row(0).border_widths = [1, 0, 1, 0]
		  column(1).width = 130
		  column(column_length - 1).align =  :left
		 row(row_length - 5).column(1).align = :left
		 row(row_length - 4).column(1).align = :left
	#	 row(row_length - 3).column(1).align = :right
#		 row(row_length - 2).column(1).align = :right
		 row(row_length - 1).font_style = :bold
		 row(row_length - 1).border_widths = [1, 0, 1, 0]
		end
		move_down(20)
		text "Total Qty: #{@sale.sale_products.sum(:qty)}", :size => 10, :align => :left
		move_up(10)
		text "Total Item: #{@sale.sale_products.length}", :size => 10, :align => :right
		#text "Sales Man:", :size => 10, :align => :right
		text (@total_sales - @discount + @vat).to_i.to_english, :size => 10, :align => :left

	end
	
	def line_item_rows
		i = 1
		@items.push ["S.No","Particulars", "Qty", "Rate", "Amount"]
		@sale.sale_products.each.map do |item| 
			@items.push ["#{i}.", item.product.name,  item.qty, item.price / item.qty, item.price]
			i += 1
		end
		if (@total_returns > 0 )
			i = 1
			@items.push ["", ".                       Sales Return", "", "", ""]
			@sale.sale_returns.each.map do |item| 
				@items.push ["#{i}.", item.product.name,  "-#{item.qty}", item.price / item.qty, "-#{item.price}"]
				i += 1
			end
		end
		if (@sale.discount > 0 )
			@items.push ["", "Total", "", "", (@total_sales.round(2))]
			@items.push ["", "Discount", "", "", (@sale.discount).to_f.round(2)]
		end
		@items.push ["", "Total", "", "", (@total_sales - @discount + @vat -@total_returns).round(2)]

		@items

		@items
	end
	
end
