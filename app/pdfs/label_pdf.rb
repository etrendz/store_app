require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

class LabelPdf < Prawn::Document
	def initialize(value, qty)
		super(options = {:margin => [10, 10, 0, 10]})
		font "Times-Roman"
		font_size 10
		@value = value
		@qty = qty
		@h = 25
		@x = 0
		@y = 0
		@xd = 0
		
stroke_circle [0, 0], 10
bounding_box([100, 300], :width => 300, :height => 200) do
stroke_bounds
        barcode = Barby::Code39.new @value
        barcode.annotate_pdf(self, {:text => @value, :align => 'left'})
end
	end
	
    def barcode(h,x,y,xd)
		puts "   ====================="
        puts  @value
        barcode = Barby::Code39.new @value
        barcode.annotate_pdf(self, {:text => @value})
    end
end
