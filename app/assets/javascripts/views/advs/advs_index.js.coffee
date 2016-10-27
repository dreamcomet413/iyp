class Widget.Views.AdvsIndex extends Backbone.View
  template: JST['advs/index']

  render: ->
    @$el.html @template()
    @$('#advs-collection').append("Featured results:") if @collection.length != 0
    @collection.each(@appendAd)
    @

  appendAd: (entry) =>
    view = new Widget.Views.Adv(model: entry)
    @$('#advs-collection').append(view.render().el)

  appendWebAd: () ->
    #new CityGrid.Ads('web-ads', {
    #  collection_id: 'web-002-300x250',
    #  # publisher: '10000003642',
    #  publisher: 'citysearch',
    #  what: 'sushi',
    #  where: '90069',
    #  lat: 34.088188,
    #  lon: -118.37205,
    #  width: 300,
    #  height: 250
    #})

