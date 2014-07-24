
$(document).ready(function(){  

	 $('#print_barcode').click(function(){ 
			ebarcode =  $(".barcode_page").html()
			$('.navbar').remove();
			$('.sidebar').remove();
			$('#breadcrumbs').remove();
			$('#ace-settings-container').remove();
			$('.page-content').empty().append('<div class="row"><div class="col-xs-12">'+ebarcode+'</div></div>');
			$('#print_barcode').remove();
			window.print();
			return false; 
			
	 });
	 
	$( "#from_date" ).datepicker({
		dateFormat: 'yy-mm-dd',
		showOtherMonths: true,
		selectOtherMonths: false,
		//isRTL:true,
	});
	$( "#to_date" ).datepicker({
		dateFormat: 'yy-mm-dd',
		showOtherMonths: true,
		selectOtherMonths: false,
		//isRTL:true,
	});
	$( "#purchase_purchase_date" ).datepicker({
		dateFormat: 'yy-mm-dd',
		showOtherMonths: true,
		selectOtherMonths: false,
		//isRTL:true,
	});
	$('#file').ace_file_input({
		no_file:'No File ...',
		btn_choose:'Choose',
		btn_change:'Change',
		droppable:false,
		onchange:null,
		thumbnail:false //| true | large
		//whitelist:'gif|png|jpg|jpeg'
		//blacklist:'exe|php'
		//onchange:''
		//
	});
	$('#product_code').keyup(function(event) {
		var name = $("#product_code").val();
		if(name.length == 6)
		{
			$.get("/product_code/" + this.value + ".json", function(data){
		 		$("#product_name").val(data.name); 
				$('.avl_qty').empty().append(data.qty);
			});	
			$("#myqty").focus();
		}
		});
		
	var xTriggered = 0;
	$('.add_purchase_products').submit(function(){
	//	alert($("#myprice").val());
		 $.ajax({
		 method:"POST",
		 url:'/purchases/add_purchase_products',
		 data: {
			product_name: $("#product_name").val(),
			cprice: $("#mycprice").val(),
			price: $("#myprice").val(),
			qty: $("#myqty").val()
			},
		 success:function(data){
			$(data).appendTo('.result_purchase_product');
			clean_product_field();
			xTriggered = 0;
		 },
		 error:function(data){
			alert("error");
			clean_product_field();
		 }
		});
		return false;
	});
	$('.add_sale_products').submit(function(){
		if (parseInt($("#avl_qty").val()) < parseInt($("#myqty").val()))
		{
		//	alert("Unable to Process");
			clean_product_field();
			$('.avl_qty').empty().append("Unable To Process");
			return false
		}
		else
		{
		 $.ajax({
		 method:"POST",
		 url:'/sales/add_sale_products',
		 data: {
			product_name: $("#product_name").val(),
			qty: $("#myqty").val(),
			price: $("#myprice").val()
			},
		 success:function(data){
			 $(data).appendTo('.result_sale_product');
			 
			clean_product_field();
		 }
		});
		
			 return false;
		}
	});
	 
	$('#select_date').datepicker({dateFormat: "yy-mm-dd",
	onClose: function(input, inst) { 
		a = 1.0;
		b= 20;
			$('.daily_report').empty().append("<div class='progress progress-striped active'><div class='bar' style='width: 0%;'></div></div>").delay(1000);
	}, 
	onSelect: function(selectedDate) {
		$.get('/daily_report?date='+selectedDate, function(data){
		  $('.daily_report').empty().append(data);
		});
	}
});
	 
	 


	$(".previous_purchase_btn").click(function() {
		  $.get('/previous_purchase?id='+ this.id, function(data){
			$('.previous_purchase').empty().append(data)
			$(".previous_purchase_btn").remove()
		});
	});

	$('#select_month').datepicker( {
		changeMonth: true,
		changeYear: true,
		showButtonPanel: true,
		dateFormat: "yy-mm-dd",
		onSelect: function(selectedMonth) {
		},
		onClose: function(dateText, inst) { 
			var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
			var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
			$(this).datepicker('setDate', new Date(year, month, 1));
			$.get('/monthly_report?date='+this.value, function(data){
			  $('.monthly_report').empty().append(data);
			});
		}
	});

	$('#from_month').daterangepicker();
	// $('#from_month').datepicker( {dateFormat: "yy-mm-dd" });
	$('#to_month').datepicker( {dateFormat: "yy-mm-dd" });
 
 	$('#sale_sale_date').datepicker({dateFormat: 'yy-mm-dd'});

 	$('#close_date').datepicker({dateFormat: 'yy-mm-dd'});
	
	
 	$('#date_picker_close').datepicker();
  /*
  	$('#product_price').change(function(){
	//	alert($("#myprice").val());
		sprice = $('#product_price').val()
		alert(sprice + 4);
	});
	*/	
	
	$( "#product_name" ).autocomplete({
	  source: $('#product_name').data('autocomplete-source'),
	  select: function( event, ui ) {
			$.get("/count?item=" + ui.item.value, function(data){
			  $('.avl_qty').empty().append(data);
			});	  
	  }
	});
	
	/*
  	$('#product_code').change(function(){
		$.get("/products/" + this.value + ".json", function(data){
		 //alert(data.qty);
		 $("#product_name").val(data.name); 
		//  $('.avl_qty').empty().append(data.qty);
		});	
	});
	
	*/
		
	function clean_product_field(){
	
		$('.avl_qty').empty();
		$("#product_code").val(""); 
		$("#product_name").val(""); 
		$("#myqty").val(""); 
		$("#myprice").val(""); 
		$("#content_1").mCustomScrollbar("update");
		$("#product_code").focus();
	}

});

