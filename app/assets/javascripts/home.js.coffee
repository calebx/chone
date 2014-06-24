$(document).ready ()->
  $uri_input  = $("#item_uri")
  $check_link = $("#check_link")

  $check_link.on 'click', (e)->
    e.preventDefault()
    location.href = $(this).attr('href') + "?uri=" + $uri_input.val()
