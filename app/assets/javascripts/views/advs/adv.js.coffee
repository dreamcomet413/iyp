class Widget.Views.Adv extends Widget.Views.BasicAdvListing
  template: JST['advs/adv']

  city: ->
    $("#city").val().replace(/(\w+)\,\s(\w+)/, "$1")

  render: ->
    @$el.html(@template(entry: @model, city: @city()))
    @displayed_at = new Date()
    @
