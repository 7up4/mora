$(".epub_reader").ready ->
  $(document).on 'turbolinks:load', -> # this executes script on every page, should be fixed
    window.reader = ePubReader($("div.opened_book").attr('data-file-address'))
    $('body:has(.opened_book)').css('overflow', 'hidden')
