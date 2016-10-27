class Widget.Views.ListingsIndex extends Backbone.View
  template: JST['listings/index']

  render: ->
    $(@el).html(@template())
    @collection.each(@appendListing)
    this

  appendListing: (entry) =>
    view = new Widget.Views.Listing(model: entry)
    @$('#listings').append(view.render().el)