// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js
// = require bootstrap-select
// = require bootstrap/alert
// = require bootstrap/dropdown
//= require jquery_ujs
//= require jquery.remotipart
//= require turbolinks
//= require rails.validations
//= require rails.validations.nested_form
//= require_tree .
//= require jquery_nested_form
//= require javascripts/libs/zip.min.js
//= require javascripts/libs/screenfull.min.js
//= require javascripts/epub.min.js
//= require javascripts/reader.min.js

$(document).on('turbolinks:load',function(){
  $('.selectpicker').selectpicker();
  $('.datepicker').datepicker({
     language: "<%= I18n.locale %>",
     format: 'yyyy-mm-dd'
  });
});
