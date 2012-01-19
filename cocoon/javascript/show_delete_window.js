/***************************/
//@Author: Adrian "yEnS" Mato Gondelle
//@website: www.yensdesign.com
//@email: yensamg@gmail.com
//@license: Feel free to use it, but keep this credits please!
/***************************/

//SETTING UP OUR POPUP
//0 means disabled; 1 means enabled;
var popupStatus = 0;

//loading popup with jQuery magic!
function loadPopup() {
	//loads popup only if it is disabled
	if (popupStatus == 0) {
		$("#backgroundPopup").fadeIn("fast");
		$('.delete_button') .parent() .children('.delete_window').fadeIn("fast");
		popupStatus = 1;
	}
}

//disabling popup with jQuery magic!
function disablePopup() {
	//disables popup only if it is enabled
	if (popupStatus == 1) {	
		location.reload(true); 
		$("#backgroundPopup").fadeOut("fast");
		$(".delete_window").fadeOut("fast");
		popupStatus = 0;		
	}
}

//centering popup
function centerPopup() {
	//request data for centering
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = $(".delete_window").height();
	var popupWidth = $(".delete_window").width();
	//centering
	$(".delete_window").css({
		"position": "fixed",
		"top": windowHeight / 2 - popupHeight / 2,
		"left": windowWidth / 2 - popupWidth / 2
	});
	//only need force for IE6
	
	$("#backgroundPopup").css({
		"height": windowHeight
	});
}


//CONTROLLING EVENTS IN jQuery
$(document).ready(function () {
	
	//LOADING POPUP
	//Click the button event!
	$(".delete_button").click(function () {
		var id = $(this) .attr('id').split('-')[1];
		var title = $(this) .attr('title');
		var baseurl = $(this) .attr('baseurl');
		var datatype = $(this) .attr('datatype');
		//centering with css
		centerPopup();
		//load popup
		//loadPopup();
		if (popupStatus == 0) {
			$('.trigger_container_header') .children('h3') .text('Delete Item');
			$("#backgroundPopup").fadeIn("fast");
			popupStatus = 1;
			$('.delete_window').children('iframe') .attr('src', baseurl + 'delete/?id=' + id + '&title=' + title + '&datatype=' + datatype);
			$('.delete_window').fadeIn("fast");
		}
	});
	
	$(".publish_checkbox").click(function () {
		var id = $(this) .attr('id').split('-')[1];
		var title = $(this) .attr('title');
		var baseurl = $(this) .attr('baseurl');
		var datatype = $(this) .attr('datatype');
		var mode;
		var label;
		if ($(this) .is(':checked')){
			mode = 'create';
			label = 'Publish Item';
		} else {
			mode = 'delete';
			label = 'Unpublish Item';
		}
		//centering with css
		centerPopup();
		//load popup
		//loadPopup();
		if (popupStatus == 0) {
			$('.trigger_container_header') .children('h3') .text(label);
			$("#backgroundPopup").fadeIn("fast");
			popupStatus = 1;
			$('.delete_window').children('iframe') .attr('src', baseurl + 'publish/?id=' + id + '&title=' + title + '&mode=' + mode + '&datatype=' + datatype);
			$('.delete_window').fadeIn("fast");
		}
	});
	
	$('.close').click(function () {
		disablePopup();
	});
	
	//CLOSING POPUP
	//Click the x event!
	$(".xforms-trigger").click(function () {
		disablePopup();
	});
	//Click out event!
	$("#backgroundPopup").click(function () {
		disablePopup();
	});
	//Press Escape event!
	$(document).keypress(function (e) {
		if (e.keyCode == 27 && popupStatus == 1) {
			disablePopup();
		}
	});
});