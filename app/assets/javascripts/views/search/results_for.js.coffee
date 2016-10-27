class Widget.Views.ResultsFor extends Backbone.View
  template: JST['search/results_for']

  render: ->
    $(@el).html(@template({model: @model}))
    this

  events:
    'click #get-better-results-link' : 'showGetBetterResults'

  showGetBetterResults: ->
    @$('#modal-get-better-results').modal('toggle')
    get_better_results = new Widget.Views.GetBetterResults
    @$('#modal-get-better-results-container').html(get_better_results.render().el)
