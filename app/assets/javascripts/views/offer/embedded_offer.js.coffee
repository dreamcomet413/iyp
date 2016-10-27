class Widget.Views.EmbeddedOffer extends Widget.Views.BasicOffer
  template: JST['offer/embedded_offer']

  render: ->
    $('body .reveal-modal').remove()
    $('body').append(@template(offer: @model))
    $('body .reveal-modal a').attr("target","_blank")
    $('body .reveal-modal').reveal()
    @




