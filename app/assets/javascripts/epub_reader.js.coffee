$(document).on 'turbolinks:load', ->
  if $("div.opened_book").length
    window.reader = ePubReader($("div.opened_book").attr('data-file-address'))
  $('body:has(.opened_book)').css('overflow', 'hidden')
