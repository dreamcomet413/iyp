class Widget.Views.BasicOffer extends Backbone.View
  el: $('body')
  events:
    'click .close-reveal-modal': "setCloseWindowTime"

  setCloseWindowTime: ->
    @requestFor "set_closed_window_time"


  requestFor: (action) ->
    $.ajax
      type: 'PUT'
      url: "/api/offer/#{action}/#{@model.get('offer_history_id')}"

  render: ->
    $('body .reveal-modal').remove()
    $('body').append(@template(offer: @model))
    $('body .reveal-modal').reveal()
    if jQuery.browser.mobile
      $('body .reveal-modal .close-reveal-modal').addClass("close-reveal-modal-mobile")
    @
