$(document).ready ()->
  $uri_input  = $("#item_uri")
  $check_link = $("#check_link")

  $uri_input.keyup ()->
    new_uri = $check_link.data("itemNewPath") + "?uri=" + $(this).val()
    $check_link.attr("href", new_uri)
