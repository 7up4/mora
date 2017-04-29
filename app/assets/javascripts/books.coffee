# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $(".hide_field").click (e) ->
    e.preventDefault();
    $(".field#"+this.id).toggleClass("hidden")
    $("#book_"+this.id).enableClientSideValidations()
  $('form').on('nested:fieldAdded', (e) ->  $(e.target).find(':input').enableClientSideValidations())
