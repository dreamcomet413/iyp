class Widget.Collections.Listings extends Backbone.Collection
  url: '/api/listings'
  fetch: (options) ->
      options or= {}
      options.data or= {}
      success = options.success
      options.success = (model, resp) =>
          @trigger 'fetch:end'
          if success then success model, resp
      error = options.error
      options.error = (originalModel, resp, options) => 
          @trigger 'fetch:end'
          if error then error originalModel, resp, options
      @trigger 'fetch:start'
      Backbone.Collection.prototype.fetch.call @, options