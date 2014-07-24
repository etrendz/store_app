class DailyReportPdf < Prawn::Document
	def initialize(materials, date)
		super(options = {:margin => [10, 10, 0, 10]})
		font "Times-Roman"
		font_size 10
		@materials = materials
		@date = date.to_date
		
		@material = Hash.new
		@opening = Hash.new
		@opening_price = Hash.new
		@arrival = Hash.new
		@arr_price = Hash.new
		@issue = Hash.new
		@iss_price = Hash.new
		@close = Hash.new
		@close_price = Hash.new
		
		@grand_open = 0
		@grand_arrival = 0
		@grand_issue = 0
		@grand_close = 0
		
		pwd = Rails.root.join('app', 'assets', 'data').to_s
		@pre_record = "#{pwd}/#{@date.year}#{@date.mon}/REC-#{@date.mday}.txt"
		File.open(@pre_record, 'r') do |f1| 
		   while line = f1.gets  
			  arr = line.split(/~ */)
				 key = arr[0].to_i
				  value = arr[9].chomp
				  @material[key] = arr[1]
				  @opening[key] = arr[2]
				  @opening_price[key] = arr[3]
				  @arrival[key] = arr[4]
				  @arr_price[key] = arr[5]
				  @issue[key] = arr[6]
				  @iss_price[key] = arr[7]
				  @close[key] = arr[8]
				  @close_price[key] = value
		   end
		end	  
		issue_number
		line_items
	end
	
	def issue_number
		text "Day Sheet", size: 26, style: :bold
		move_down 20
		text "Date: #{@date.strftime('%d-%b-%y')}", size: 16
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
	
end
