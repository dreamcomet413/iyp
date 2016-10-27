class Widget.Views.NotFound extends Backbone.View
  template: JST['search/not_found']

  render: ->
    $(@el).html(@template({model: @model}))
    this
