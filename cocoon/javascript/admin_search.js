/************************************
ADMIN SEARCH
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
populates hidden query parameter in admin section search for editing documents, based on earlier quick search js on results page.
************************************/
$(function () {
	$('#qs_button') .click(function () {
		var strHref = window.location.href;
		var search_text = $('#qs_text') .attr('value');
		if (strHref.indexOf('mode=ead') > 0) {
			$('#qs_query') .attr('value', search_text + ' AND objectType_facet:coin');
		} else if (strHref.indexOf('mode=vra') > 0) {
			$('#qs_query') .attr('value', search_text + ' AND NOT objectType_facet:coin');
		}
	});
});