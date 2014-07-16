$(document).ready ()->
  $uri_input  = $("#item_uri")
  $check_link = $("#check_link")

  $check_link.on 'click', (e)->
    console.log "good start"
    location.href = $(this).attr('href') + "?uri=" + $uri_input.val()
