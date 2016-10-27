window.Widget =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new Widget.Routers.Listings()
    Backbone.history.start()

$(document).ready ->
  Widget.init()
  $('#myModal').modal show: false

  $('.input_1').qtip
    content:
      text: "Enter city/state in this format:  Seattle, WA"
    style:
      tip:
        corner: true
    position:
      my: 'bottom center'
      at: 'top center'
      target: $('.input_1')

  $("#category").keypress (event) =>
    if  event.which == 13
      $('#category').autocomplete('close')

  $("#category").focusin (event) =>
    $('#city').autocomplete('close')

  if jQuery.browser.mobile
    navigator.geolocation.getCurrentPosition(
      ((p) ->
        $('#geolocation').val("#{p.coords.latitude},#{p.coords.longitude}")
        $.ajax
          type: 'POST'
          url: "/api/geocoder/city_and_state"
          data:
            position:
              lat: p.coords.latitude 
              lon: p.coords.longitude
          success: (resp) ->
            $("input#city").val(resp.city_and_state.city_and_state)
          error: (resp) ->
            console.error "Unable to retrieve geo data from the browser."
        $.cookie('city')
      )
      ((msg) -> "error: #{msg}" )
    )
