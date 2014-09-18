
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
	 
	 $('#supplierwise').change(function(){ 
			$('#hiddendate').removeClass("hiddendate");
			return false; 
			
	 });

	 $('#customerwise').change(function(){ 
			$('#hiddendate').removeClass("hiddendate");
	//		alert('dd');
			return false; 
			
	 });
	 
	 $('#purchase_receipt_type').change(function(){ 
		alert('changed');
		$.get("/purchases/last/" + this.value + ".json", function(mydata){
			$('#purchase_invoice').val(mydata); 
		//	alert(typeof(mydata));
		});	
		return false; 
			
	 });
	 
	 $('#sale_sale_type').change(function(){ 
		$.get("/sales/last/" + this.value + ".json", function(mydata){
			$('#sale_invoice').val(mydata); 
		//	alert(typeof(mydata));
		});	
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
	$( "#purchase_invoice_date" ).datepicker({
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
		if($("#product_code").val().length == 6)
		{
			$.get("/product_code/" + this.value + ".json", function(data){
		 		$("#product_name").val(data.name); 
				$('.avl_qty').empty().append(data.qty);
				$('#mycprice').val(data.cprice);
				$('#myqty').val(1);
				$('#myprice').val(data.price);
			});	
			$("#myprice").focus();
		}
	});
		
	$('.add_purchase_products').submit(function(){
		 $.ajax({
		 method:"POST",
		 url:'/purchases/add_purchase_products',
		 data: {
			product_name: $("#product_name").val(),
			product_code: $("#product_code").val(),
			cprice: $("#mycprice").val(),
			bill_qty: $("#bill_qty").val(),
			rec_qty: $("#rec_qty").val(),
			price: $("#myprice").val(),
			qty: $("#myqty").val()
			},
		 success:function(data){
			$('.result_purchase_product').prepend(data); 
			cprice = $("input[id=purchase_new_purchase_product_attributes__cprice]").first().val();
			var tpsum = $('#total_purchase_sum').text();
			var qty = parseInt($("#myqty").val()) || 1;
			tpsum = parseFloat(tpsum) + (cprice *  qty);
			$('#total_purchase_sum').empty().append(tpsum);
			calculate_purchase_discount();
			calculate_excise_duty();
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
		var myurl = '/sales/add_sale_products';
		if ($("#sale_version").val() == 'Return') {
			myurl = '/sales/add_sale_returns';
		}
		else {
			myurl = '/sales/add_sale_products';
		}
		if ((parseInt($(".avl_qty").html())) < parseInt($("#myqty").val()) &&( myurl !='/sales/add_sale_returns') )
		{
			clean_product_field();
			alert("Stock not Available");
			return false
		}
		else
		{
		 $.ajax({
		 method:"POST",
		 url: myurl,
		 data: {
			product_name: $("#product_name").val(),
			product_code: $("#product_code").val(),
			qty: $("#myqty").val(),
			price: $("#myprice").val()
			},
		 success:function(data){
			
			html = $.parseHTML( data )
			htm = html[1];
	
			match = 0;
			$("input[id=sale_new_sale_product_attributes__product_id]").each(function() {
				if ($(this).val() == htm.childNodes[1].childNodes[5].childNodes[1].value) {
					$(this).next("input[id=sale_new_sale_product_attributes__qty]").val(parseInt($(this).next("input[id=sale_new_sale_product_attributes__qty]").val()) + parseInt(htm.childNodes[1].childNodes[5].childNodes[3].value));
					mysum = parseFloat($(this).next().next("input[id=sale_new_sale_product_attributes__price]").val()) + parseFloat(htm.childNodes[1].childNodes[5].childNodes[5].value);
				//	alert(mysum);
					$(this).next().next("input[id=sale_new_sale_product_attributes__price]").val(mysum);
					$(this).closest('fieldset').find('#visible_qty').text(parseInt($(this).next("input[id=sale_new_sale_product_attributes__qty]").val()));
					$(this).closest('fieldset').find('#visible_sum_price').text(mysum);
					var tsprice = $('#total_sale_price').text();
					tsprice = parseFloat(tsprice) + parseFloat(htm.childNodes[1].childNodes[5].childNodes[5].value);
					$('#total_sale_price').empty().append(tsprice);
					calculate_total(tsprice);
					match = 1;
				}
			});
			if (match == 0) {
			  if (htm.childNodes[1].childNodes[5].childNodes[1].id == 'sale_new_sale_product_attributes__product_id') {
				$('.result_sale_product').prepend(data); 
	//			$(data).appendTo('.result_sale_product');       //changed by ehti to bring the latest element added to the top
				var price = $("input[id=sale_new_sale_product_attributes__price]").first().val();
				var tsprice = $('#total_sale_price').text();
				var tqty = $('#total_qty').text();
				var qty = parseInt($("#myqty").val()) || 1;
				tqty = parseFloat(tqty) + qty;
				tsprice = parseFloat(tsprice) + parseFloat(price);
				
				$('#total_sale_price').empty().append(tsprice);
				calculate_total(tsprice);
				$('#total_qty').empty().append(tqty);
			  }
			  else if (htm.childNodes[1].childNodes[5].childNodes[1].id == 'sale_new_sale_return_attributes__product_id') {
	//			$('.result_sale_product').append(data); 
				$(data).appendTo('.result_sale_product');       //changed by ehti to bring the latest element added to the top
				var price = $("input[id=sale_new_sale_return_attributes__price]").last().val();
				var tsprice = $('#total_sale_price').text();
				var tqty = $('#total_qty').text();
				var qty = parseInt($("#myqty").val()) || 1;
				tqty = parseFloat(tqty) - qty;
				tsprice = parseFloat(tsprice) - parseFloat(price);
				
				$('#total_sale_price').empty().append(tsprice);
				calculate_total(tsprice);
				$('#total_qty').empty().append(tqty);
			  }
			}
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
	 
	 function calculate_total(sub_total) {
		discount_percent = $("#sale_discount").val(); 
		discount = sub_total * discount_percent / 100;
		$('#net_sale_price').empty().append(sub_total - discount);

	 }
	 
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
	
	 
 //	$('#sale_sale_date').datepicker({dateFormat: 'yy-mm-dd'});

 	$('#close_date').datepicker({dateFormat: 'yy-mm-dd'});
	
	
 	$('#date_picker_close').datepicker();
	
	function calculate_purchase_discount() {
		var tsum = parseFloat($("#total_purchase_sum").text()) || 0;
		var discount_percent = parseFloat($("#purchase_discount").val()) || 0;
		var discount_value = tsum * discount_percent / 100;
//		alert($("#discount_percent"));
		$("#discount_percent").empty().append(discount_percent);
		$("#discount_value").empty().append(discount_value);
		$("#actual_total").empty().append(tsum - discount_value);
	}
	
	function calculate_excise_duty() {
		var atotal = parseFloat($("#actual_total").text()) || 0;
		var duty_percent = parseInt($("#duty_percent").text()) || 0;
		var duty_value = atotal * duty_percent / 100;
		var edu_cess_percent = parseInt($("#purchase_edu_cess").val()) || 0;
		var edu_cess_value = duty_value * edu_cess_percent / 100;
		var surcharge_percent = parseInt($("#purchase_surcharge").val()) || 0;
		var surcharge_value = duty_value * surcharge_percent / 100;
		var excise_duty = duty_value + edu_cess_value + surcharge_value;
		var vat_cst_percent = parseInt($("#purchase_vat").val()) || 0;
		var freight = parseInt($("#purchase_freight").val()) || 0;
		var dc = parseInt($("#purchase_dc").val()) || 0;
		var vat_cst_value = (atotal + excise_duty + freight + dc)  * vat_cst_percent / 100;
		var invoice_amount = parseInt($("#purchase_amount").val());
		$("#duty_value").empty().append(duty_value.toFixed(2));
		$("#edu_cess_value").empty().append(edu_cess_value.toFixed(2));
		$("#surcharge_value").empty().append(surcharge_value.toFixed(2));
		$("#excise_duty").empty().append(excise_duty.toFixed(2));
		$("#vat_cst_value").empty().append(vat_cst_value.toFixed(2));
		round_off = invoice_amount - (atotal + excise_duty + freight + dc + vat_cst_value) ;
		$("#round_off").empty().append(round_off.toFixed(2));
		grand_total = atotal + excise_duty + freight + dc + vat_cst_value + round_off;
		$("#grand_total").empty().append(grand_total.toFixed(2));
//		debit_amt = parseInt(Math.abs(round_off.toFixed(2)));
		var debit_amt = parseFloat($("#purchase_debit_note").val()) || 0;
		$("#debit_amt").empty().append(debit_amt);
		net_total = grand_total - debit_amt;
		$("#net_total").empty().append(net_total.toFixed(2));
		
		$("#purchase_round_off").val(round_off.toFixed(2));
//		$("#purchase_debit_note").val(debit_amt);
	}
	
	
/*	
COMMENTED BY EHTI AND ADDED THE SAME IN PURCHASE NEW.HTML FOR TESTING CUSTOM DATA
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
*/	


	
	
	
	$("#app_product_name").autocomplete({
	  source: $('#app_product_name').data('autocomplete-source'),
	  select: function( event, ui ) {
			this.form.action =this.form.action + '?name=' + ui.item.value
			this.form.submit();
	  }
	});
	
	function clean_product_field(){
	
		$('.avl_qty').empty().append("Avl");
		$("#product_code").val(""); 
		$("#product_name").val(""); 
		$("#myqty").val(""); 
		$("#margin").val(""); 
		$("#myprice").val(""); 
		$("#bill_qty").val(""); 
		$("#rec_qty").val(""); 
		$("#mycprice").val(""); 
		$("#content_1").mCustomScrollbar("update");
		$("#product_code").focus();
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
		calculate_purchase_discount();
		calculate_excise_duty();
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
		calculate_total(tsprice);
		$(this).closest('fieldset').remove();
		$("#content_1").mCustomScrollbar("update");
		event.preventDefault();
	});
	
	$('form').on('click', '.remove_return_field', function(event) {
		var qty = $(this).closest('fieldset').find('#sale_new_sale_return_attributes__qty').val();
		var price = $(this).closest('fieldset').find('#sale_new_sale_return_attributes__price').val();
		var tqty = $("#total_qty").text(); 
		var tsprice = $("#total_sale_price").text(); 
		tqty =  parseInt(tqty) + parseInt(qty);
		tsprice =  parseFloat(tsprice) + parseFloat(price);
		$('#total_qty').empty().append(tqty);
		$('#total_sale_price').empty().append(tsprice);
		calculate_total(tsprice);
		$(this).closest('fieldset').remove();
		$("#content_1").mCustomScrollbar("update");
		event.preventDefault();
	});
	$("#sale_discount").change(function(){
		sub_total = parseInt($('#total_sale_price').text());
		total = sub_total * this.value / 100;
		
		$('#net_sale_price').empty().append(sub_total - total);
	});	
	
	$("#sale_customer_name").autocomplete({
	  source: $('#sale_customer_name').data('autocomplete-source'),
	  select: function( event, ui ) {
//			this.form.action =this.form.action + '?name=' + ui.item.value
//			this.form.submit();
	  }
	});
	
	
	$('#bootbox-regular').on('click', function(){
bootbox.confirm("<form id='infos' action=''>\
    Discount Amount: <input type='text' id='amt'></input><br/><br/>\
    Discount Percent: <input type='text' id='percent'></input><br/>\
    <p>Please Add any one</p>\
    </form>", function(result) {
			if (result === null) {
				//alert("Prompt dismissed");
			} 
			else {
				if ($('#amt').val() != '') {
					var tsprice = $('#total_sale_price').text();
					$('#sale_discount').val(parseFloat($('#amt').val()) * 100 / parseFloat(tsprice));
					calculate_total(tsprice);
					$('#temp_discount').val($('#amt').val());
					$('#temp_discount').css('display','block');
					
				}
				else if ($('#percent').val() != '') {
					var tsprice = $('#total_sale_price').text();
				//	alert(parseFloat($('#amt').val()) * 100 / parseFloat(tsprice));
					$('#sale_discount').val($('#percent').val());
					calculate_total(tsprice);
					$('#temp_discount').val($('#percent').val());
					$('#temp_discount').css('display','block');
				}
			}
		});
	});
	
});
