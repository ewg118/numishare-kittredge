/************************************
JQUERY SIMPLE TABS
Written by Ethan Gruber, ewg4x@virginia.edu
Library: jQuery
Description: Handles tabs for showing/hiding specific sections of pages.
Implemented in the search forms for navigating between basic and
advanced search, but importantly used for navigating between
commentary and metadata in the coin records.
************************************/
$(function () {
	$('.yui-nav') .children('li') .click(function(){
		if ($(this) .attr('class') != 'selected'){
			$(this) .parent('.yui-nav') .children('li[class=selected]') .removeAttr('class');
			$(this) .attr('class', 'selected');
			var section = $(this) .attr('id').split('_')[0];
			$(this) .parent('.yui-nav') .parent ('.yui-navset') .children('.yui-content') .children ('div[class!=hidden]').attr('class', 'hidden');
			$('#' + section) .removeAttr('class');
		} 
	});
})