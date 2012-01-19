/************************************
TOGGLE SEARCH OPTIONS
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
Description: This javascript file handles the dynamic search form
in the search and search results pages.  Some fields require
text boxes, some require the entry of integers to search a range,
and the remaining query solr and return unique facets and write
them to the drop-down menu.
************************************/

$(document).ready(function() {	
	$('.category_list') .livequery('change', function(event){
		var selected_id = $(this) .children("option:selected") .attr('id');
		var num = $(this) .parent() .attr('id') .split('_')[1];
		
		if ($('#' + selected_id).attr('value').indexOf('text') > 0 || $('#' + selected_id).attr('value').indexOf('display') > 0) {
			if ($(this) .parent() .children('.option_container') .children('input') .attr('class') != 'search_text') {
				$(this) .parent() .children('.option_container') .html('');
				$(this) .parent() .children('.option_container') .html('<input type="text" id="search_text" class="search_text"/>');
			}
		}
		//YEAR
		else if (selected_id == 'year_option') {
			$(this) .parent() .children('.option_container') .html('From: <input type="text" class="from_date"/>' +
			'<select class="from_era"><option value="minus">B.C.</option><option value="" selected="selected">A.D.</option></select>' +
			'To: <input type="text" class="to_date"/>' +
			'<select class="to_era"><option value="minus">B.C.</option><option value="" selected="selected">A.D.</option></select>');
		}
		//WEIGHT
		else if (selected_id == 'weight_option') {
			$(this) .parent() .children('.option_container') .html('<select class="weight_range">' +
			'<option value="lessequal">Less/Equal to</option><option value="equal">Equal to</option><option value="greaterequal">Greater/Equal to</option>' +
			'</select><input type="text" class="weight_int"/> grams');
		}
		//DIMENSIONS
		else if (selected_id == 'dimensions_option') {
			$(this) .parent() .children('.option_container') .html('<select class="dimensions_range">' +
			'<option value="lessequal">Less/Equal to</option><option value="equal">Equal to</option><option value="greaterequal">Greater/Equal to</option>' +
			'</select><input type="text" class="dimensions_int"/> mm');
		}
		//SELECTING OTHER DROP DOWN MENUS SECTION
		else {
			var category = $(this) .children("option:selected") .attr('value');
			$(this) .parent('.searchItemTemplate') .children('.option_container') .html('<img style="margin-left:100px;margin-right:100px;" src="images/ajax-loader.gif"/>');
			$.get('get_search_facets', {
				q : category + ':[* TO *]', category:category
			}, function (data) {
				$('#container_' + num) .html(data);
			});				
		}
	});
});