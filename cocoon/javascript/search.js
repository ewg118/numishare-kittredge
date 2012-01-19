/************************************
SEARCH
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
Description: Portions of this originally authored by Matt Mitchell.
Modified heavily to handle the search form functionality
and piecing together the search query.
************************************/
$(document).ready(function() {
	
	// display error if server doesn't respond
	$("#search") .ajaxError(function (request, settings) {
		$(this) .html('<div id="error">Error requesting page/service unavailable.</div>');
	});
	
	// total options for advanced search - used for unique id's on dynamically created elements
	var total_options = 1;
	
	// the boolean (and/or) items. these are set when a new search criteria option is created
	var gate_items = {
	};
	
	// focus the text field after selecting the field to search on
	$('.searchItemTemplate select') .change(function () {
		$(this) .siblings('.search_text') .focus();
	})
	// copy the base template
	
	
	function gateTypeBtnClick(btn) {
		// increment - this is really just used to created unique ids for new dom elements
		total_options++;
		
		var tpl = $('#searchItemTemplate') .clone();
		
		// reset the id
		tpl.attr('id', 'searchItemTemplate_' + total_options);
		// reset the copied item's select element id
		$(tpl) .children('select') .attr('id', 'search_option_' + total_options);
		$(tpl) .children('div') .attr('id', 'container_' + total_options);
		// reset the copied item's remove button id
		$(tpl) .children('#removeBtn_1') .attr('id', 'removeBtn_' + total_options);
		
		// focus the text field after select
		$(tpl) .children('select') .change(function () {
			$(this) .siblings('input') .focus();
		});
		
		// assign the handler for all gateTypeBtn elements within the new item/template
		$(tpl) .children('.gateTypeBtn') .click(function () {
			gateTypeBtnClick($(this));
		});
		
		// store in a "lookup" object
		gate_items[total_options] = btn.text();
		
		// add the new template to the dom
		$(btn) .parent() .after(tpl);
		
		// display the entire new template
		tpl.fadeIn('slow');
		
		// re-adjust the footer (footer is absolutely positioned)
		$('#footer') .css('top', $('#advancedSearchForm') .height() + 'px');
		
		// text style the remove part of the new template
		$('#removeBtn_' + total_options) .before(' |&nbsp;');
		
		// make the remove button visible
		$('#removeBtn_' + total_options) .css('visibility', 'visible');
		// assign the remove button click handler
		$('#removeBtn_' + total_options) .click(function () {
			var id = $(this) .attr('id');
			var num = id.substring(id.indexOf('_') + 1);
			// remove the gate/boolean item so the query is still valid
			delete gate_items[num];
			// fade out the entire template
			$(this) .parent() .fadeOut('slow', function () {
				$(this) .remove();
			});
			// move the footer back up
			$('#footer') .css('top', $('#advancedSearchForm') .height() + 'px');
		});
	}
	
	// assign the gate/boolean button click handler
	$('.gateTypeBtn') .click(function () {
		gateTypeBtnClick($(this));
	})
	
	$('#advancedSearchForm').submit(function() {
		assembleQuery();
	});
	
	
	// activates the advanced search action
	function assembleQuery(){
		var query = new Array();
		
		// loop through each ".searchItemTemplate" and build the query
		$('#advancedSearchForm .searchItemTemplate') .each(function () {
			var val = $(this) .children('.category_list') .attr('value');
			
			if ((val != 'year_num' && val != 'weight_num' && val != 'dimensions_num') && $(this) .children('.option_container') .children('.search_text') .attr('value').length > 0) {
				query.push (val + ':' + $(this) .children('.option_container') .children('.search_text') .attr('value'));
			} else if (val == 'weight_num' &&  $(this) .children('.option_container') .children('.weight_int') .attr('value').length > 0) {
				var string = '';
				string += '(' + val;
				var weight = $(this) .children('.option_container') .children('.weight_int') .attr('value');
				var range_value = $(this) .children('.option_container') .children('.weight_range') .attr('value');
				if (range_value == 'lessequal') {
					string += ':[* TO ' + weight + ']';
				} else if (range_value == 'greaterequal') {
					string += ':[' + weight + ' TO *]';
				} else if (range_value == 'equal') {
					string += ':' + weight;
				}
				string += ')';
				query.push(string);
			} else if (val == 'dimensions_num' && $(this) .children('.option_container') .children('.dimensions_int') .attr('value').length > 0) {
				var string = '';
				string += '(' + val;
				var dimensions = $(this) .children('.option_container') .children('.dimensions_int') .attr('value');
				var range_value = $(this) .children('.option_container') .children('.dimensions_range') .attr('value');
				if (range_value == 'lessequal') {
					string += ':[* TO ' + dimensions + ']';
				} else if (range_value == 'greaterequal') {
					string += ':[' + dimensions + ' TO *]';
				} else if (range_value == 'equal') {
					string += ':' + dimensions;
				}
				string += ')';
				query.push(string);
			} else if (val == 'year_num' && ($(this) .children('.option_container') .children('.from_date') .attr('value').length > 0 || $(this) .children('.option_container') .children('.to_date') .attr('value').length > 0)) {
				var string = '';
				string += val + ':';
				var from_date = $(this) .children('.option_container') .children('.from_date') .attr('value').length > 0 ? $(this) .children('.option_container') .children('.from_date') .attr('value') : '*';
				var from_era = $(this) .children('.option_container') .children('.from_era') .attr('value') == 'minus' ? '-' : '';
				
				var to_date = $(this) .children('.option_container') .children('.to_date') .attr('value').length > 0 ? $(this) .children('.option_container') .children('.to_date') .attr('value') : '*';
				var to_era = $(this) .children('.option_container') .children('.to_era') .attr('value') == 'minus' ? '-' : '';
				
				string += '[' + (from_date == '*' ? '' : from_era) + from_date + ' TO ' + (to_date == '*' ? '' : to_era) + to_date + ']';
				query.push(string);
			}
		});
		// pass the query to the search_results url passing the needed url params:
		if (query.length == 0){
			$('#q_input') .attr('value', '*:*');
		} else {
			$('#q_input') .attr('value', query.join(' AND '));
		}
		
	};
});
	
