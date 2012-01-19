/************************************
REMOVE FILTER
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
fade out the stacked filters on the search results page
************************************/
$(function () {
	$('.remove_filter') .click(function () {
		$(this).parent('.stacked_term').fadeOut('slow');
	});
});