$(document).ready(function(){
	$("#checkAll").attr("data-type","check");
	$("#checkAll").click(function(){
		if($("#checkAll").attr("data-type")==="check")
          {
            $(".first").prop("checked",true); 
			$("#checkAll").attr("data-type","uncheck");
			countChecked();
			
          }
        else
          {
            $(".first").prop("checked",false);
		    $("#checkAll").attr("data-type","check");
			countChecked();
			
          }
	}) 
	var countChecked = function() {
				var n = $( "input:checked" );
				var total_checks = 0;
				for(var i=0;i < n.length; i++) {
				total_checks += parseInt($('input[name='+n[i].name.replace("check", "qty")+']').val());
				}
				// alert(total_checks);
				$( ".counting_check" ).text(total_checks);
				};
				//countChecked();

				$( "input[type=checkbox]" ).on( "click", countChecked );
				
});