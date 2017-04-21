$(".epub_reader").ready ->
  $(document).on 'turbolinks:load', ->
    window.reader = ePubReader($("div.opened_book").attr('data-file-address'))
    $('body:has(.opened_book)').css('overflow', 'hidden')
