class Widget.Views.Notification extends Backbone.View
  template: JST['notifications/notification']

  render: ->
    $(@el).html(@template())
    this

  events:
    "click .close" : "remove_element"

  remove_element: ->
    $(@el).fadeOut('fast', ->
      $(@el).remove())

  remove_element_slowly: ->
    that = @
    setInterval (->
      $(that.el).fadeOut('slow', ->
        $(that.el).remove())
    ), 5000
