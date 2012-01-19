$(document).ready(function () {
	$('.chartConfigurator')
	.find('.typeOptions>.fieldGroup>input[type=radio]')
	.bind('updateDependencies', function () {
		if ($(this).is(':checked')) {
			$(this).next().next(':hidden').slideDown(function () {
				$(this).find('input,select').removeAttr('disabled');
			});
		} else {
			$(this).next().next(':visible').slideUp(function () {
				$(this).find('input,select').attr('disabled', 'disabled');
			});
		}
	})
	.trigger('updateDependencies')
	.click(function () {
		$('.typeOptions>.fieldGroup>input[type=radio]').trigger('updateDependencies');
	})
	.end();
});