class Widget.Routers.Listings extends Backbone.Router
  routes:
    '' : 'index'

  initialize: ->
    @collection   = new Widget.Collections.Listings()
    @advs         = new Widget.Collections.Advs()
    @suggestions  = new Widget.Collections.Suggestions()
    @collection.reset($('#search-results').data('listings'))
    @advs.reset($('#advs').data('advs'))

  index: ->
    view = new Widget.Views.SearchIndex({collection: @collection, advs: @advs, suggestions: @suggestions})
    $('#container').html(view.render().el)
