/************************************
GET FACET TERMS IN RESULTS PAGE
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
Description: This utilizes ajax to populate the list of terms in the facet category in the results page.  
If the list is populated and then hidden, when it is re-activated, it fades in rather than executing the ajax call again.
************************************/
$(document).ready(function() {
	
	var popupStatus = 0;
	//set category button label on page load
	category_label();

	$("#backgroundPopup").livequery('click', function(event) {
		disablePopup();
	});
	
	//hover over remove facet link
	$(".remove_filter").hover(
		function () {
			$(this).parent().addClass("ui-state-hover");
		},
		function () {
			$(this).parent().removeClass("ui-state-hover");
		}
	);
	$("#clear_all").hover(
		function () {
			$(this).parent().addClass("ui-state-hover");
		},
		function () {
			$(this).parent().removeClass("ui-state-hover");
		}
	);

	//enable multiselect
	$(".multiselect").multiselect({	
   		//selectedList: 3,   		
   		minWidth:'auto',
   		header:'<a class="ui-multiselect-none" href="#"><span class="ui-icon ui-icon-closethick"/><span>Uncheck all</span></a>',
   		create: function(){
   			var title = $(this).attr('title');
   			var array_of_checked_values = $(this).multiselect("getChecked").map(function(){
				return this.value;
			}).get();	
			var length = array_of_checked_values.length;
			
			if (length > 3){
				$('button[title=' + title + ']').children('span:nth-child(2)').text(title + ': ' + length + ' selected');
			} else if (length > 0 && length <= 3){
				$('button[title=' + title + ']').children('span:nth-child(2)').text(title + ': ' + array_of_checked_values.join(', '));
			} else if (length == 0){
				$('button[title=' + title + ']').children('span:nth-child(2)').text(title);
			}
   		},
   		open: function(){      			
      			var id = $(this) .attr('id');
      			if ($('#' + id).html().indexOf('<option') < 0){
	      			var q = $(this).attr('q');
	      			var category = id.split('-select')[0];
	      			var mincount = $(this).attr('mincount');
	      			$.get('get_facet_options', {
					q: q, category: category, sort: 'index', limit:-1, offset:0, mincount:mincount
					},
					function (data) {
						$('#' + id) .html(data);
						$("#" + id).multiselect('refresh')
					}
				);
			}
   		},
   		//close menu: restore button title if no checkboxes are selected
   		close: function(){
   			var title = $(this).attr('title');
      			var id = $(this) .attr('id');
      			var array_of_checked_values = $(this).multiselect("getChecked").map(function(){
				return this.value;
			}).get();	
			if (array_of_checked_values.length == 0){
				$('button[title=' + title + ']').children('span:nth-child(2)').text(title);
			}
   		},
   		click: function(){
   		   	var title = $(this).attr('title');
   		   	var id = $(this) .attr('id');
   			var array_of_checked_values = $(this).multiselect("getChecked").map(function(){
				return this.value;
			}).get();	
			var length = array_of_checked_values.length;
			if (length > 3){
				$('button[title=' + title + ']').children('span:nth-child(2)').text(title + ': ' + length + ' selected');
			} else if (length > 0 && length <= 3){
				$('button[title=' + title + ']').children('span:nth-child(2)').text(title + ': ' + array_of_checked_values.join(', '));
			} else if (length == 0){
				var q = $(this).attr('new_query');
				if (q.length > 0){
					var category = id.split('-select')[0];
					var mincount = $(this).attr('mincount');
					$.get('get_facet_options', {
						q: q, category: category, sort: 'index', limit:-1, offset:0, mincount:mincount
						},
						function (data) {
							$('#' + id) .attr('new_query', '');
							$('#' + id) .html(data);
							$('#' + id).multiselect('refresh');
						}
					);
				}
			}
   		}, 
   		uncheckAll: function(){
   			var id = $(this) .attr('id');
   			var q = $(this).attr('new_query');
   			if (q.length > 0){
				var category = id.split('-select')[0];				
				var mincount = $(this).attr('mincount');
				$.get('get_facet_options', {
					q: q, category: category, sort: 'index', limit:-1, offset:0, mincount:mincount
					},
					function (data) {
						$('#' + id) .attr('new_query', '');
						$('#' + id) .html(data);
						$('#' + id).multiselect('refresh');
					}
				);
			}
   		}
	}).multiselectfilter();
	
	$('#category_facet_link').hover(function () {
    		$(this) .attr('class', 'ui-multiselect ui-widget ui-state-default ui-corner-all ui-state-focus');
	}, 
	function () {
		$(this) .attr('class', 'ui-multiselect ui-widget ui-state-default ui-corner-all');
	});
	
	$('.category-close') .click(function(){
		disablePopup();
	});

	$('#category_facet_link').click(function () {
		if (popupStatus == 0) {
			$("#backgroundPopup").fadeIn("fast");
			popupStatus = 1;
		
		}
		var list_id = $(this) .attr('id').split('_link')[0] + '-list';
		var category = $(this) .attr('id') .split('_link')[0];
		var q = $(this) .attr('label');	
		if ($('#' + list_id).html().indexOf('<li') < 0) {
			$.get('get_categories', {
					q: q, category: category, prefix: 'L1', fq: '*', section: 'collection', link: ''
				},
				function (data) {
					$('#' + list_id) .html(data);
				});								
		}
		$('#' + list_id).parent('div').attr('style', 'width: 192px;display:block;');
	});
	
	//expand category when expand/compact image pressed
	$('.expand_category') .livequery('click', function(event){		
		var fq = $(this) .attr('id').split('__')[0];
		var list = fq.split('|')[1] + '__list';
		var prefix = $(this).attr('next-prefix');
		var q = $(this) .attr('q');
		var section = $(this) .attr('section');
		var link = $(this) .attr('link');
		if ($(this) .children('img') .attr('src') .indexOf('plus') >= 0) {
			$.get('get_categories', {
				q: q, prefix: prefix, fq: '"' + fq.replace('_', ' ') + '"', link: link, section: section
			},
			function (data) {
				$('#' + list) .html(data);			
			});
			$(this) .parent('.term') .children('.category_level') .show();
			$(this) .children('img') .attr('src', $(this) .children('img').attr('src').replace('plus', 'minus'));
		} else {
			$(this) .parent('.term') .children('.category_level') .hide();
			$(this) .children('img') .attr('src', $(this) .children('img').attr('src').replace('minus', 'plus'));	
		}
	});
	
	//remove all ancestor or descendent checks on uncheck
	$('.term input') .livequery('click', function(event){	
		if ($(this) .is(':checked')) {
			$(this) .parents('.term') .children('input') .attr('checked', true);
		} else {
			$(this) .parent('.term') .children('.category_level') .find('input').attr('checked', false);
			//on unchecking, repopulate the categories
			if ($(this) .parent().parent().parent().children('span').attr('class') == 'expand_category'){
				var fq = $(this) .parent().parent().parent().children('.expand_category').attr('id').split('__')[0];				
				var list = fq.split('|')[1] + '__list';
				var prefix = $(this).parent().parent().parent().children('.expand_category').attr('next-prefix');			
				var section = $(this).parent().parent().parent().children('.expand_category') .attr('section');
				var link = $(this).parent().parent().parent().children('.expand_category') .attr('link');				
				var query = getQuery();
				$.get('get_categories', {
					q: query, prefix: prefix, fq: '"' + fq.replace('_', ' ') + '"', link: link, section: section
					},
					function (data) {
						$('#' + list) .html(data);			
				});
			} else {			
				var query = getQuery();
				$.get('get_categories', {
					q: query, category: 'category_facet', prefix: 'L1', fq: '*', section: 'collection', link: ''
				},
				function (data) {
					$('#category_facet-list') .html(data);
				});			
			}
		}
		var count_checked = 0;
		$('.term input').each(function () {
   			if (this.checked) {
   				count_checked++;
   			}
		});
		
		if (count_checked > 0){
			category_label();
		} else {
			$('#category_facet_link').attr('title', 'Category');
			$('#category_facet_link').children('span:nth-child(2)').html('Category');
		}
	});
	
	$('#search_button') .click(function () {
		var query = getQuery();
		
		//set the value attribute of the q param to the query assembled by javascript
		$('#facet_form_query').attr('value', query);
	});
	
	function getQuery(){
		//get categories
		var query = '';
		
		//get non-facet fields that may have been passed from search
		var query_terms = $('#facet_form_query').attr('value').split(' AND ');	
		var non_facet_terms = new Array();
		for (i in query_terms){
			if (query_terms[i].indexOf('_facet') < 0 && query_terms[i].indexOf('century_num') < 0 && query_terms[i].indexOf('dob_num') < 0 && query_terms[i] != '*:*'){
				non_facet_terms.push(query_terms[i]);				
			}
		}
		if (non_facet_terms.length > 0){
			query += ' AND ' + non_facet_terms.join(' AND ');
		}
		
		categories = new Array();
		$('.term') .children('input:checked') .each(function () {
			if ($(this) .parent('.term') .html() .indexOf('category_level') < 0 || $(this) .parent('.term') .children('ul') .html() .indexOf('<li') < 0 || $(this) .parent('.term') .children('.category_level').find('input:checked').length == 0) {
				segment = new Array();
				$(this) .parents('.term').each(function () {
					segment.push('+"' + $(this).children('input').val() + '"');
				});
				var joined = 'category_facet:(' + segment.join(' ') + ')';
				categories.push(joined);
			}
		});
		//if the categories array is not null, establish the category query string
		if (categories[0] != null) {
			if (categories.length > 1) {
				query += ' AND (' + categories.join(' OR ') + ')';
			} else {
				query += ' AND ' + categories[0];
			}
		}
		
		//get multiselects
		$('.multiselect').each(function () {
			var facet = $(this).attr('id').split('-')[0];
			segment = new Array();
			$(this) .children('option:selected').each(function () {
				if ($(this) .val().length > 0){
					segment.push(facet + ':"' + $(this).val() + '"');
				}				
			});
			if (segment[0] != null) {
				if (segment.length > 1){
					query += ' AND (' + segment.join(' OR ') + ')';
				}
				else {
					query += ' AND ' + segment[0];
				}
			}
		});
		
		if ($('#imagesavailable') .is(':checked')) {
			query += ' AND imagesavailable:true';
		}
		
		if (query.length > 0){
			query = query.substring(5);
		} else {
			query = '*:*';
		}	
		return query;
	}
	
	/***************************/
	//@Author: Adrian "yEnS" Mato Gondelle
	//@website: www.yensdesign.com
	//@email: yensamg@gmail.com
	//@license: Feel free to use it, but keep this credits please!
	/***************************/
	
	//disabling popup with jQuery magic!
	function disablePopup() {
		//disables popup only if it is enabled
		if (popupStatus == 1) {	
			$("#backgroundPopup").fadeOut("fast");
			$('#category_facet-list') .parent('div').attr('style', 'width: 192px;');
			popupStatus = 0;		
		}
	}
	
});
	function category_label(){
		categories = new Array();
		$('.term') .children('input:checked') .each(function () {
			if ($(this) .parent('.term') .html() .indexOf('category_level') < 0 || $(this) .parent('.term') .children('ul') .html() .indexOf('<li') < 0 || $(this) .parent('.term') .children('.category_level').find('input:checked').length == 0) {
				segment = new Array();
				$(this) .parents('.term').each(function () {
					segment.push($(this).children('input').val().split('|')[1]);
				});
				var joined = segment.reverse().join('--');
				categories.push(joined);
				if (categories.length > 0 && categories.length <= 3){
					$('#category_facet_link').attr('title', 'Category: ' + categories.join(', '));
					$('#category_facet_link').children('span:nth-child(2)').text( 'Category: ' + categories.join(', '));
				} else if (categories.length > 3){
					$('#category_facet_link').attr('title',  'Category: ' + categories.length + ' selected');
					$('#category_facet_link').children('span:nth-child(2)').text( 'Category: ' + categories.length + ' selected');
				} 
			}
		});
	}