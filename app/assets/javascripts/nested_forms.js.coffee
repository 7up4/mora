$(document).ready ->
  $(document).on 'turbolinks:load', ->
    if $('.duplicatable_nested_form').length
      nestedForms = []

      $('.duplicatable_nested_form').each ->
        nestedFormId = $(this).attr("id")
        nestedForms[nestedFormId]=$('.duplicatable_nested_form#'+nestedFormId).last().clone()

      $('.duplicate_nested_form').click (e) ->
        currentNestedFormId = $(this).attr("id")

        lastNestedForm = $('.duplicatable_nested_form#'+currentNestedFormId).last()
        newNestedForm  = nestedForms[currentNestedFormId].clone()
        formsOnPage    = $('.duplicatable_nested_form#'+currentNestedFormId).length

        $(newNestedForm).find('label').each ->
          oldLabel = $(this).attr 'for'
          newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'for', newLabel

        $(newNestedForm).find('select, input, textarea').each ->
          oldId = $(this).attr 'id'
          newId = oldId.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'id', newId

          oldName = $(this).attr 'name'
          newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[#{formsOnPage}]")
          $(this).attr 'name', newName

        $( newNestedForm ).insertAfter( lastNestedForm ).slideDown()
        return false
