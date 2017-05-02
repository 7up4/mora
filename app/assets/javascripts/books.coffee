# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $(".hide_field").click (e) ->
    e.preventDefault();
    $(".field#"+this.id).toggleClass("hidden")
    $("#book_"+this.id).enableClientSideValidations()
  # Enable client side validatons for nested_form
  $('form').on('nested:fieldAdded', (e) ->  $(e.target).find(':input').enableClientSideValidations())
  # Disable validation for select if there are nested forms
  $('form').on('nested:fieldAdded:authors', (e) -> $("#book_author_ids").disableClientSideValidations())
  $('form').on('nested:fieldRemoved:authors', (e) ->
    if !$(".nested_author_fields:visible").length
      $("#book_author_ids").enableClientSideValidations())
