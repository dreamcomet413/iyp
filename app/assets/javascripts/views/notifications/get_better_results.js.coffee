class Widget.Views.GetBetterResults extends Backbone.View
  template: JST['notifications/get_better_results']

  render: ->
    $(@el).html(@template())
    this

