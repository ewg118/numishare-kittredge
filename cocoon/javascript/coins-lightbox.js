/************************************
COINS LIGHTBOX
Written by Ethan Gruber, gruber@numismatics.org
Library: jQuery
Description: This activates the jquery lightbox for
links featuring the class jqueryLightbox.  This is activated
in the search results pages.
************************************/
$(function () {
	$('.jqueryLightbox') .lightBox({
		fixedNavigation: true,
		imageLoading: 'images/lightbox-ico-loading.gif',
		imageBtnClose: 'images/lightbox-btn-close.gif',
		imageBtnPrev: 'images/lightbox-btn-prev.gif',
		imageBtnNext: 'images/lightbox-btn-next.gif'
	});
});
