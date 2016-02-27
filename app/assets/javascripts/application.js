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
//= require jquery
//= require jquery_ujs
//= require jquery
//= require materialize-sprockets
//= require_tree .
// var loaded = function(){
//
//   $(document).ready(function() {
//     $('.modal-trigger').leanModal();
//     $(".button-collapse").sideNav();
//
//     var $chips = $('.chip');
//
//     $('#name_search_name').keyup('change', function () {
//     var currentName = this.value;
//     $chips.each(function (index, chip) {
//       $chip = $(chip);
//       if ($chip.data('name').includes(currentName)) {
//         $chip.show();
//       } else {
//         $chip.hide();
//       }
//     });
//   });
//   });
// }

$(document).ready(function() {
    $('select').material_select();
});

// $(document).on("page:load ready", loaded);

// $.getJSON('/').then(whaever)
