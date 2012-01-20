$(document).ready(function () {
	//hover over terms
	$(".filter_facet").livequery(function(){ 
		$(this) .hover(function () {
				$(this).addClass("ui-state-hover");
			}, function () {
				$(this).removeClass("ui-state-hover");
		});
	});
	$("#backgroundPopup").livequery('click', function (event) {
		disablePopup();
	});
	
	var popupStatus = 0;
	var q = '*:*';
	initialize_map(q);
	maps_update_filters(q);
	
	//functions
	function maps_update_filters(q){
		//clear html from ul
		$.get('maps_update_filters', {
			q: q
		}, function (data) {
			$('#filter_list').html(data);
		});
	}
	
	function maps_get_facets(q, category, sort, limit, offset){
		//clear html from ul
		$.get('maps_get_facets', {
				q: q, category: category, sort: sort, limit: limit, offset: offset
			},
			function (data) {				
				$('#' + category + '-list').html(data);
			});
		$('#' + category + '-list') .fadeIn('slow');
		$('#' + category + '-list') .removeClass('hidden');
		if (popupStatus == 0) {
			$(this) .parent().addClass('ui-state-active')
			$("#backgroundPopup").fadeIn("fast");
			popupStatus = 1;
		}
	}
	
	function maps_remove_facets (q){
		//clear html from div
		$.get('maps_remove_facets', {
			q: q
		},
		function (data) {		
			$('.remove_facets').html(data);
		});	
				
	}
	
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
		maps_remove_facets(q);
		disablePopup();
		initialize_map(q);		
	});
	
	//click on a non-category term
	$('.ft span').livequery('click', function (event) {
		$('#basicMap').html('');
		var href = $(this).attr('href');
		var q = href.split('=')[1];
		$('#query').attr('value', q);
		maps_remove_facets(q);
		maps_update_filters(q);
		disablePopup();
		initialize_map(q);
	});
	
	//click on a category term
	/*$('.category_term').livequery('click', function (event) {
		$('#basicMap').html('');
		var href = $(this).attr('href');
		if ($('#query').attr('value') == '*:*') {
			var source = '';
		} else {
			var source = $('#query').attr('value') + ' AND ';
		}
		$('#query').attr('value', source + href.split('=')[1]);
		var q = $('#query').attr('value');
		maps_remove_facets(q);
		maps_update_filters(q);
		disablePopup();
		initialize_map(q);
	});*/
	
	//remove a filter
	$('.remove_filter').livequery('click', function (event) {
		$('#basicMap').html('');
		var q = unescape($(this).attr('href')).split('=')[1];
		maps_remove_facets(q);
		maps_update_filters(q);
		$('#query').attr('value', q);
		initialize_map(q);
		return false;
	});
	
	//clear search facets, reset query
	$('#clear_terms').livequery('click', function (event) {
		var q = '*:*';
		$('#basicMap').html('');
		maps_remove_facets(q);
		maps_update_filters(q);
		$('#query').attr('value', q);
		initialize_map(q);
		return false;
	});
	
	//clear ajax results div
	$('#clear_all').livequery('click', function (event) {
		$('#results').empty();		
	});
	
	$('.filter_heading').livequery('click', function (event) {
		var category = $(this) .parent() .attr('id') .split('_link')[0];
		var q = $('#query').attr('value');
		var sort = 'index';
		var limit = 20;
		var offset = 0;
		maps_get_facets(q, category, sort, limit, offset);
	});
	
	/*$('.expand_category') .livequery('click', function (event) {
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
	});*/
	
	$('.sort_facet').livequery('click', function (event) {
		var category = $(this) .attr('id') .split('-')[0];
		var list_id = category + '-list';
		var q = $('#query').attr('value');
		var sort = $(this) .attr('id') .split('-')[1];
		var limit = 20;
		var offset = 0;
		maps_get_facets(q, category, sort, limit, offset);
	});
	
	$('.page-facets').livequery('click', function (event) {
		
		var category = $(this) .attr('id') .split('-')[0];
		var list_id = category + '-list';
		var q = $('#query').attr('value');
		var offset = $(this) .attr('title').split(':')[0];
		var sort = $(this) .attr('title').split(':')[1];
		var limit = 20;
		maps_get_facets(q, category, sort, limit, offset);
	});
	
	$('.close_facets').livequery('click', function (event) {
		var category = $(this) .attr('id') .split('-')[0];
		var list_id = category + '-list';
		disablePopup();
	});
	
	$('a.pagingBtn') .livequery('click', function (event) {
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