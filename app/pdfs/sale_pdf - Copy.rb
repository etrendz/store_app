class IssuePdf < Prawn::Document
	def initialize(issue, view)
		super(options = {:margin => [10, 0, 0, 10]})
		@issue = issue
		issue_number
		line_items
	end
	
	def issue_number
		text "Indent \##{@issue.indent}", size: 30, style: :bold
	end
	def line_items
		move_down 20
		table line_item_rows do
		  row(0).font_style = :bold
		  self.row_colors = ["DDDDDD", "FFFFFF"]
		  self.header = true
		end
	end
	
	def line_item_rows
		[["Material", "Qty"]] + 
		@issue.issue_materials.each.map do |item|
			[item.material.name, item.qty]
		end
	end
end