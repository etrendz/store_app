
$(document).ready(function(){
		
	 function inline_edit() {
		alert('link clicked');
	 }
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
	 
	 $('#supplierwise').change(function(){ 
			$('#hiddendate').removeClass("hiddendate");
			return false; 
			
	 });

	 $('#customerwise').change(function(){ 
			$('#hiddendate').removeClass("hiddendate");
	//		alert('dd');
			return false; 
			
	 });
	 $('#margin').change(function(){ 
			var margin = parseFloat($("#mycprice").val()) + (parseInt($(this).val()) * parseFloat($("#mycprice").val()) / 100);
			$("#myprice").val(margin);
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
	$('#sale_product_code').keyup(function(event) {
		if($("#sale_product_code").val().length == 6)
		{
			$.get("/product_code/" + this.value + ".json", function(data){
				
		 		$("#product_name").val(data.name); 
				$("#myqty").val(1);
				$('.avl_qty').empty().append(data.qty);
				$.get("/stock_products_price/" + data.id + ".json", function(mydata){
						$("#myprice").val(mydata.price); 
				});	
		//	alert("Name : " + $("#product_name").val() + " Qty : " + $("#myqty").val() + " Price : " + $("#myprice").val());
			$('.add_sale_products').submit();
			});	
		clean_product_field();
		}
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
		
	$('.add_purchase_products').submit(function(){
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
			$('.result_purchase_product').prepend(data); 
			cprice = $("input[id=purchase_new_purchase_product_attributes__cprice]").first().val();
			var tpsum = $('#total_purchase_sum').text();
			var tqty = $('#total_qty').text();
			var qty = parseInt($("#myqty").val()) || 1;
			tqty = parseFloat(tqty) + qty;
			tpsum = parseFloat(tpsum) + (cprice *  qty);
			$('#total_purchase_sum').empty().append(tpsum);
			$('#total_qty').empty().append(tqty);
		//	alert('' + tqty);
			clean_product_field();
		 },
		 error:function(data){
			alert("error");
			clean_product_field();
		 }
		});
		return false;
	});
	$('.add_sale_products').submit(function(){
		if ((parseInt($(".avl_qty").html())) < parseInt($("#myqty").val()))
		{
			clean_product_field();
			alert("Unable To Process");
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
			$('.result_sale_product').prepend(data); 
//			$(data).appendTo('.result_sale_product');       //changed by ehti to bring the latest element added to the top
			var price = $("input[id=sale_new_sale_product_attributes__price]").first().val();
			var tsprice = $('#total_sale_price').text();
			var tqty = $('#total_qty').text();
			var qty = parseInt($("#myqty").val()) || 1;
			tqty = parseFloat(tqty) + qty;
			tsprice = parseFloat(tsprice) + parseFloat(price);
			
			$('#total_sale_price').empty().append(tsprice);
			$('#total_qty').empty().append(tqty);
			clean_product_field();
		 },
		 error:function(data){
			alert("error");
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

	$('#from_month').datepicker( {dateFormat: "yy-mm-dd" });
	$('#to_month').datepicker( {dateFormat: "yy-mm-dd" });
	
	 
 	$('#sale_sale_date').datepicker({dateFormat: 'yy-mm-dd'});

 	$('#close_date').datepicker({dateFormat: 'yy-mm-dd'});
	
	
 	$('#date_picker_close').datepicker();
	
	
	$("#product_name").autocomplete({
	  source: $('#product_name').data('autocomplete-source'),
	  select: function( event, ui ) {
			$.get("/count.json?item=" + ui.item.value, function(data){
			  $('.avl_qty').empty().append(data.qty);
			  $('#product_code').val(data.code);
			  $('.avl_qty').empty().append(data.qty);
			  
			  $.get("/stock_products_price/" + data.id + ".json", function(mydata){
				if ($('#margin').length == 0) {
					$("#myprice").val(mydata.price); 
					
				}
				$("#myqty").focus(); 
			  });	
              			  
			});	  
	  }
	});
	
	$("#app_product_name").autocomplete({
	  source: $('#app_product_name').data('autocomplete-source'),
	  select: function( event, ui ) {
			this.form.action =this.form.action + '?name=' + ui.item.value
			this.form.submit();
	  }
	});
	
	function clean_product_field(){
	
		$('.avl_qty').empty().append("Avl");
		$("#sale_product_code").val(""); 
		$("#product_code").val(""); 
		$("#product_name").val(""); 
		$("#myqty").val(""); 
		$("#margin").val(""); 
		$("#myprice").val(""); 
		$("#mycprice").val(""); 
		$("#content_1").mCustomScrollbar("update");
		$("#sale_product_code").focus();
	}
 	$('#sale_sale_date').datepicker({dateFormat: 'yy-mm-dd'});

 	$('#close_date').datepicker({dateFormat: 'yy-mm-dd'});
	
	
 	$('#date_picker_close').datepicker();
	
	
	$('form').on('click', '.remove_fields', function(event) {
		var qty = $(this).closest('fieldset').find('#sale_new_sale_product_attributes__qty').val();
		var tqty = $("#total_qty").text(); 
		tqty =  parseInt(tqty) - parseInt(qty);
		$('#total_qty').empty().append(tqty);
		$(this).prev('input[type=hidden]').val(1);
		
		$(this).closest('fieldset').remove();
		event.preventDefault();
	});
	$('form').on('click', '.remove_ext_field', function(event) {
		var qty = $(this).closest('fieldset').find('#purchase_new_purchase_product_attributes__qty').val() ||  $(this).closest('fieldset').find('#sale_new_sale_product_attributes__qty').val();
		var cprice = $(this).closest('fieldset').find('#purchase_new_purchase_product_attributes__cprice').val();
		var tqty = $("#total_qty").text(); 
		var tpprice = $("#total_purchase_sum").text(); 
		tqty =  parseInt(tqty) - parseInt(qty);
		tpprice =  parseFloat(tpprice) - parseFloat(cprice) *  parseInt(qty);
		$('#total_qty').empty().append(tqty);
		$('#total_purchase_sum').empty().append(tpprice);
		$(this).closest('fieldset').remove();
		$("#content_1").mCustomScrollbar("update");
		event.preventDefault();
	});
	
	$('form').on('click', '.remove_sale_field', function(event) {
		var qty = $(this).closest('fieldset').find('#sale_new_sale_product_attributes__qty').val();
		var price = $(this).closest('fieldset').find('#sale_new_sale_product_attributes__price').val();
		var tqty = $("#total_qty").text(); 
		var tsprice = $("#total_sale_price").text(); 
		tqty =  parseInt(tqty) - parseInt(qty);
		tsprice =  parseFloat(tsprice) - parseFloat(price);
		$('#total_qty').empty().append(tqty);
		$('#total_sale_price').empty().append(tsprice);
		$(this).closest('fieldset').remove();
		$("#content_1").mCustomScrollbar("update");
		event.preventDefault();
	});
		
	
	$("#sale_customer_name").autocomplete({
	  source: $('#sale_customer_name').data('autocomplete-source'),
	  select: function( event, ui ) {
//			this.form.action =this.form.action + '?name=' + ui.item.value
//			this.form.submit();
	  }
	});
});
