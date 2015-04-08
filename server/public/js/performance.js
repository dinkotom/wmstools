var STATE_DEFAULT = "default";
var STATE_FAILURE = "failed";
var STATE_LINK = "link";

var current_page = 1;
var current_suite;


$(document).ready(function() {

	$.ajax({
	  	type: "GET",
	  	url: "performance/suites"
	})
	.done(function(data) {

		JSON.parse(data).forEach(function(d){
			$("#performance_test_suits").append('<option value="' + d.name + '">' + d.name + '</option>');
		});


		var page = GetQueryStringParams('page');
		var suite = decodeURI(GetQueryStringParams('suite'));


		if(page != undefined && suite != undefined)
		{
			$( "#performance_test_suits" ).val(suite);
			current_suite = suite;
			current_page = page;
		} 
		else
		{
			current_suite = encodeURI($( "#performance_test_suits" ).val());
		}

		getSuites(current_suite);
	});



	function GetQueryStringParams(sParam)
	{
	    var sPageURL = window.location.search.substring(1);
	    var sURLVariables = sPageURL.split('&');
	    for (var i = 0; i < sURLVariables.length; i++) 
	    {
	        var sParameterName = sURLVariables[i].split('=');
	        if (sParameterName[0] == sParam) 
	        {
	            return sParameterName[1];
	        }
		}
	}
});


function getSuites(suite)
{	
	$.ajax({
  		type: "GET",
  		url: "performance/suites/" + suite + "/" + current_page
	})
	.done(function(data) {
		buildTable(JSON.parse(data));
	});
}

$("#performance_test_suits").change(function(){

	current_suite = encodeURI($(this).val());

	getSuites(current_suite);
});




function buildTable(data)
{
	
	var pagination_data = data[0];
	data.splice(0,1);
	createPagination(pagination_data.this_page_number, pagination_data.number_of_pages)
	

	//clear table
	$("#test_executions > thead").empty();
	$("#test_executions > tbody").empty();

	var table_row;
	var cell_type;
	var header_value_row = "<tr>";

	data.forEach(function(d){
		
		table_row = "";
		cell_type = d.style == "header" ? "th" : "td";

		table_row += '<tr ' + (d.style == STATE_FAILURE ? 'style="background-color:#FFE6E6;"' : "") + '>';

		for(column in d.columns)
		{
			
			table_row += '<' + cell_type + ' style="text-align: center;">';
			
			if(cell_type == "th")
			{
				//if header then print column name
				table_row += "<div>" + column + "</div>";
				header_value_row += "<th>" + d.columns[column].value + "</th>"
			}
			else
			{
				//column value
				table_row += '<span ' + (d.columns[column].style == STATE_FAILURE ? 'style="color:red;font-weight:bold;"' : "") + '>';
				table_row += d.columns[column].style == STATE_LINK ? '<a href="' + d.columns[column].link + '" class="redirect_link">' + d.columns[column].value + "</a>" : d.columns[column].value
				table_row += '</span>';	
			}

			table_row += "</" + cell_type + ">"	
		}

		table_row += "</tr>";
		header_value_row += "</tr>";

		

		if(d.style == "header")
		{
			$('#test_executions > thead:last').append(table_row);
			$('#test_executions > thead:last').append(header_value_row);
		}
		else
		{
			$('#test_executions > tbody:last').append(table_row);
		}

		
	});
}

function switch_page(page)
{
	current_page = page;
	getSuites(encodeURI($("#performance_test_suits").val()));
}

function createPagination(current_page, total_pages)
{

	var button = "";
	for(var i = 1; i < total_pages+1; i++)
	{
		button += '<button type="button" ';
		
		if(i == current_page)
		{
			button += 'class="paginate_active" ';	
		}
		else
		{
			button += 'class="paginate_button" ';
		}
		
		button += 'onclick="switch_page(' + i + ');"';
		button += '>' + i + '</button>'; 
	}	
	$("#table_pagination").empty();
	$("#table_pagination").append(button);
}



$(document).on("click",".redirect_link",function(e){
	e.preventDefault();
	var path = $(this).attr("href") + "?" + "back=performance" + "&" + "suite=" + current_suite + "&" + "page=" + current_page;
	location.href = path;
});
