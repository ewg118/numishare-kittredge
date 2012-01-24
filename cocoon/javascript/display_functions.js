$(document).ready(function () {
	$('a.thumbImage').fancybox();

	$('#weights').visualize({
		width: 800,
		type: "bar",
		barMargin: 25,
		barGroupMargin: 10
	});
	//hide table
	$('#weights').addClass('accessHide');
	
	$('#submit-weights').click(function () {
		var selection = new Array();
		$('.weight-checkbox:checked').each(function(){
			selection.push($(this).val());
		});
		var q = selection.join(' AND ');
		$('#weights-q').attr('value', q);
	});
});