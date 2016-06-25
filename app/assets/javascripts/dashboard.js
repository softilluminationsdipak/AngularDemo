// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require dashboard/modernizr.custom.js
//= require dashboard/matchMedia.js
//= require dashboard/jquery.js
//= require jquery_ujs
//= require dashboard/bootstrap.js
//= require dashboard/jquery.storageapi.js
//= require dashboard/jquery.easing.js
//= require dashboard/animo.js
//= require dashboard/jquery.slimscroll.min.js
//= require dashboard/screenfull.js
//= require dashboard/jquery.localize.js
//= require dashboard/demo-rtl.js
//= require dashboard/index.js
//= require dashboard/jquery.flot.js
//= require dashboard/jquery.flot.tooltip.min.js
//= require dashboard/jquery.flot.resize.js
//= require dashboard/jquery.flot.pie.js
//= require dashboard/jquery.flot.time.js
//= require dashboard/jquery.flot.categories.js
//= require dashboard/jquery.flot.spline.min.js
//= require dashboard/jquery.classyloader.min.js
//= require dashboard/moment-with-locales.min.js
//= require dashboard/demo-flot.js
//= require dashboard/jquery.validate.js
//= require dashboard/jquery.inputmask.bundle.js
//= require dashboard/bootstrap-datepicker.min.js
//= require dashboard/select2.js
//= require dashboard/bootstrap-filestyle.js
//= require dashboard/app.js
//= require jquery_nested_form
//= require dashboard/clinics.js
//= require dashboard/provider.js
//= require dashboard/patient.js
//= require dashboard/letter.js
//= require dashboard/insurance_carriers.js
//= require dashboard/attorneys.js
//= require dashboard/referrers.js
//= require dashboard/diagnosis_codes.js
//= require dashboard/procedure_codes.js
//= require dashboard/accounts.js
//= require dashboard/patient_cases.js
//= require dashboard/patient_visits.js
//= require dashboard/patient_visit_details.js
//= require dashboard/rooms.js
//= require dashboard/appointments.js
//= require sweetalert2
//= require turbolinks


$(".calendar").datepicker({ format: "dd/mm/yyyy" });

$(document).on('ready page:load', function (event) {
	formatCalendarTextFields();
});

function formatCalendarTextFields(){
	$("input.calendar22").change(function(event){
		$('input.autoSubmit').closest("form").submit();
	})
}

$("#contact-select").change(function(){
	clinic_id 	= $(this).data('clinic-id');
	contact_id 	= $(this).val();
	window.location.href = '/clinics/'+clinic_id+'/appointments/week_at_glance?contact_id='+contact_id
})