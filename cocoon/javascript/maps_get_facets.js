/************************************
GET FACET TERMS IN RESULTS PAGE
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
Description: This utilizes ajax to populate the list of terms in the facet category in the results page.
If the list is populated and then hidden, when it is re-activated, it fades in rather than executing the ajax call again.
************************************/
$(document).ready(function () {
	//hover over terms
	$(".filter_facet").livequery(function(){ 
		$(this) .hover(function () {
				$(this).addClass("ui-state-hover");
			}, function () {
				$(this).removeClass("ui-state-hover");
		});
	});
	$(".remove_filter").livequery(function(){ 
		$(this) .hover(function () {
				$(this).parent().addClass("ui-state-hover");
			}, function () {
				$(this).parent().removeClass("ui-state-hover");
		});
	});
	$("#clear_terms").livequery(function(){ 
		$(this) .hover(function () {
				$(this).parent().addClass("ui-state-hover");
			}, function () {
				$(this).parent().removeClass("ui-state-hover");
		});
	});	

	$('.departments').children('input[type=checkbox]').click(function () {
		var departments = new Array();
		var query_string = '';
		$('.departments').children('input:checked').each(function () {
			departments.push('"' + $(this).val() + '"');
		});
		if (departments.length > 0) {
			query_string = 'department_facet:(' + departments.join(' OR ') + ')';
			$('#query').attr('value', query_string);
			$('#basicMap').html('');
			initialize_map(query_string);
			$.get('remove_maps_facets', {
				q: query_string
			},
			function (data) {
				$('.remove_facets') .html(data);
			});
			$.get('update_maps_filters', {
				q: query_string
			},
			function (data) {
				
				$('#filter_list') .html(data);
			});
		} else {
			$('#basicMap').html('');
			$('#filter_list').html('');
			$('.remove_facets').html('');
			$('#query').attr('value', '');
			display_terrain();
		}
	});
	
	var popupStatus = 0;
	var section = $('#filter_list').attr('section');
	var pipeline = 'get_' + section + '_facets';
	display_terrain();
	
	//click on a non-category term
	$('.fn span').livequery('click', function (event) {
		$('#basicMap').html('');
		var href = $(this).attr('href');
		if ($('#query').attr('value') == '*:*') {
			var source = '';
		} else {
			var source = $('#query').attr('value') + ' AND ';
		}
		$('#query').attr('value', source + href.split('=')[1]);
		var q = $('#query').attr('value');
		$.get('remove_maps_facets', {
			q: q
		},
		function (data) {
			$('.remove_facets') .html(data);
		});
		$.get('update_maps_filters', {
			q: q
		},
		function (data) {
			
			$('#filter_list') .html(data);
		});
		disablePopup();
		initialize_map(q);
	});
	
	//click on a non-category term
	$('.ft span').livequery('click', function (event) {
		$('#basicMap').html('');
		var href = $(this).attr('href');
		var q = href.split('=')[1];
		$('#query').attr('value', q);
		$.get('remove_maps_facets', {
			q: q
		},
		function (data) {
			$('.remove_facets') .html(data);
		});
		$.get('update_maps_filters', {
			q: q
		},
		function (data) {
			$('#filter_list') .html(data);
		});
		disablePopup();
		initialize_map(q);
	});
	
	//click on a category term
	$('.category_term').livequery('click', function (event) {
		$('#basicMap').html('');
		var href = $(this).attr('href');
		if ($('#query').attr('value') == '*:*') {
			var source = '';
		} else {
			var source = $('#query').attr('value') + ' AND ';
		}
		$('#query').attr('value', source + href.split('=')[1]);
		var q = $('#query').attr('value');
		$.get('remove_maps_facets', {
			q: q
		},
		function (data) {
			$('.remove_facets') .html(data);
		});
		$.get('update_maps_filters', {
			q: q
		},
		function (data) {
			$('#filter_list') .html(data);
		});
		disablePopup();
		initialize_map(q);
	});
	
	//remove a filter
	$('.remove_filter').livequery('click', function (event) {
		$('#basicMap').html('');
		var q = unescape($(this).attr('href')).split('=')[1];
		$.get('remove_maps_facets', {
			q: q
		},
		function (data) {
			$('.remove_facets') .html(data);
		});
		$.get('update_maps_filters', {
			q: q
		},
		function (data) {
			$('#filter_list') .html(data);
		});
		$('#query').attr('value', q);
		initialize_map(q);
		return false;
	});
	
	$('#clear_terms').livequery('click', function (event) {
		var q = $(this).attr('q');
		$('#basicMap').html('');
		$.get('remove_maps_facets', {
			q: q
		},
		function (data) {
			$('.remove_facets') .html(data);
		});
		$.get('update_maps_filters', {
			q: q
		},
		function (data) {
			$('#filter_list') .html(data);
		});
		$('#query').attr('value', q);
		initialize_map(q);
		return false;
	});
	
	$('.filter_heading').livequery('click', function (event) {
		var list_id = $(this) .parent() .attr('id').split('_link')[0] + '-list';
		var category = $(this) .parent() .attr('id') .split('_link')[0];
		var q = $('#query').attr('value');
		if (category == 'category_facet') {
			$.get('get_categories', {
				q: q, category: category, prefix: 'L1', fq: '*', section: 'search', mode: 'maps'
			},
			function (data) {
				$('#' + list_id) .html(data);
			});
		} else {
			$.get(pipeline, {
				q: q, category: category, sort: 'index', limit: 20, offset: 0
			},
			function (data) {
				$('#' + list_id) .html(data);
			});
		}
		//$(this) .attr('class', 'facet_label facet_label_selected')
		$('#' + list_id) .fadeIn('slow');
		$('#' + list_id) .removeClass('hidden');
		if (popupStatus == 0) {
			$(this) .parent().addClass('ui-state-active')
			$("#backgroundPopup").fadeIn("fast");
			popupStatus = 1;
		}
	});
	$("#backgroundPopup").livequery('click', function (event) {
		disablePopup();
	});
	
	$('.expand_category') .livequery('click', function (event) {
		var fq = $(this) .attr('id').split('__')[0];
		var list = fq.split('|')[1] + '__list';
		var prefix = $(this).attr('next-prefix');
		var q = $('#query').attr('value');
		var section = $(this) .attr('section');
		var link = $(this) .attr('link');
		if ($(this) .children('img') .attr('src') .indexOf('plus') >= 0) {
			$.get('get_categories', {
				q: q, prefix: prefix, fq: '"' + fq.replace('_', ' ') + '"', link: link, section: 'search', mode: 'maps'
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
	
	$('.sort_facet').livequery('click', function (event) {
		var category = $(this) .attr('id') .split('-')[0];
		var list_id = category + '-list';
		var q = $('#query').attr('value');
		var sort = $(this) .attr('id') .split('-')[1];
		$.get(pipeline, {
			q: q, category: category, sort: sort, limit: 20, offset: 0, sectin: section
		},
		function (data) {
			$('#' + list_id) .html(data);
		});
	});
	
	$('.page-facets').livequery('click', function (event) {
		
		var category = $(this) .attr('id') .split('-')[0];
		var list_id = category + '-list';
		var q = $('#query').attr('value');
		var offset = $(this) .attr('title').split(':')[0];
		var sort = $(this) .attr('title').split(':')[1];
		$.get(pipeline, {
			q: q, category: category, sort: sort, limit: 20, offset: offset, section: section
		},
		function (data) {
			$('#' + list_id) .html(data);
		});
	});
	
	$('.close_facets').livequery('click', function (event) {
		var category = $(this) .attr('id') .split('-')[0];
		var list_id = category + '-list';
		disablePopup();
	});
	
	$('#imagesavailable') .click(function () {
		var q = $('#query').attr('value');
		if ($('#imagesavailable input:checked').val() !== undefined) {
			var new_query = query + ' AND imagesavailable:true';
			location.href = 'maps?q=' + new_query;
		} else {
			var new_query = query.replace(' AND imagesavailable:true', '');
			location.href = 'maps?q=' + new_query;
		}
	});
	
	$('#clear_coins').livequery('click', function (event) {
		$('#results').html('');
		return false;
	});
	
	$('.pagingBtn') .livequery('click', function (event) {
		var href = 'results_ajax' + $(this) .attr('href');
		$.get(href, {
		},
		function (data) {
			$('#results') .html(data);
		});
		return false;
	});
	
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
			$('.filter_terms') .fadeOut('fast');
			$('.ui-state-active').removeClass('ui-state-active');
			popupStatus = 0;
		}
	}
});